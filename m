Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaF0UV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:21:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:24497 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750714AbaF0UV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:21:27 -0400
Date: Fri, 27 Jun 2014 16:21:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: handle NULL comm name in .dat file
Message-ID: <20140627162123.3f9be953@gandalf.local.home>
In-Reply-To: <1403799732-30308-1-git-send-email-jbacik@fb.com>
References: <1403799732-30308-1-git-send-email-jbacik@fb.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 09:22:12 -0700
Josef Bacik <jbacik@fb.com> wrote:

> Sometimes the comm field in the trace.dat file can be empty which means that the
> event parsing stuff can pass a NULL into pevent_register_comm.  To fix this just
> check if we are NULL and generate a bogus comm name for that PID.  This keeps us
> from segfaulting.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Applied, thanks!

-- Steve

> ---
>  event-parse.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/event-parse.c b/event-parse.c
> index 18b3587..00304fe 100644
> --- a/event-parse.c
> +++ b/event-parse.c
> @@ -303,7 +303,10 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
>  	if (!item)
>  		return -1;
>  
> -	item->comm = strdup(comm);
> +	if (comm)
> +		item->comm = strdup(comm);
> +	else
> +		item->comm = strdup("<...>");
>  	if (!item->comm) {
>  		free(item);
>  		return -1;

