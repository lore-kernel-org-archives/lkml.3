Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbaFZRoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:44:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32787 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757978AbaFZRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:44:37 -0400
Date: Thu, 26 Jun 2014 13:44:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] kernel/trace/trace.c: remove unnecessary null test
 before debugfs_remove
Message-ID: <20140626134435.2cb2e047@gandalf.local.home>
In-Reply-To: <1403802871-8599-1-git-send-email-fabf@skynet.be>
References: <1403802871-8599-1-git-send-email-fabf@skynet.be>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 19:14:31 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> This fixes checkpatch warning:
> 
> "WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Thanks, applied to my 3.17 queue.

-- Steve

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/trace/trace.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 384ede3..58c78e4 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6095,10 +6095,8 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
>  	if (!topts)
>  		return;
>  
> -	for (cnt = 0; topts[cnt].opt; cnt++) {
> -		if (topts[cnt].entry)
> -			debugfs_remove(topts[cnt].entry);
> -	}
> +	for (cnt = 0; topts[cnt].opt; cnt++)
> +		debugfs_remove(topts[cnt].entry);
>  
>  	kfree(topts);
>  }

