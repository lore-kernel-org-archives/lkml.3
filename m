Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3CGGOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:14:35 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34635 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3CGGOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:14:34 -0500
X-AuditID: 85900ec0-d60ccb900000151e-1b-513830477563
Message-ID: <51382FEB.2010301@hitachi.com>
Date: Thu, 07 Mar 2013 15:12:59 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: unknown
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 2/2] tracing: Do not return EINVAL in snapshot when
 not allocated
References: <20130306134916.923746858@goodmis.org> <20130306135122.481660396@goodmis.org>
In-Reply-To: <20130306135122.481660396@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(03/06/2013 10:49 PM), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)"<srostedt@redhat.com>
> 
> To use the tracing snapshot feature, writing a '1' into the snapshot
> file causes the snapshot buffer to be allocated if it has not already
> been allocated and dose a 'swap' with the main buffer, so that the
> snapshot now contains what was in the main buffer, and the main buffer
> now writes to what was the snapshot buffer.
> 
> To free the snapshot buffer, a '0' is written into the snapshot file.
> 
> To clear the snapshot buffer, any number but a '0' or '1' is written
> into the snapshot file. But if the file is not allocated it returns
> -EINVAL error code. This is rather pointless. It is better just to
> do nothing and return success.
> 
> Cc: Hiraku Toyooka<hiraku.toyooka.gu@hitachi.com>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---

Acked-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

>   kernel/trace/trace.c |    2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9e3120b..1f835a8 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4167,8 +4167,6 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
>   	default:
>   		if (current_trace->allocated_snapshot)
>   			tracing_reset_online_cpus(&max_tr);
> -		else
> -			ret = -EINVAL;
>   		break;
>   	}
>   
> -- 1.7.10.4 .
> 

