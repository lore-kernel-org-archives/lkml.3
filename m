Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3FULM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:12:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53488 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FULM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 07:12:58 -0400
Message-ID: <51C43537.8070300@hitachi.com>
Date: Fri, 21 Jun 2013 20:12:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] tracing: fix disabling of soft disable
References: <cover.1371751701.git.tom.zanussi@linux.intel.com> <f369f565dc440f40f027de0387c99dda4d36154e.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <f369f565dc440f40f027de0387c99dda4d36154e.1371751701.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/21 3:31), Tom Zanussi wrote:
> The comment on the soft disable 'disable' case of
> __ftrace_event_enable_disable() states that the soft disable bit
> should be cleared in that case, but currently only the soft mode bit
> is actually cleared.
> 
> This essentially leaves the standard non-soft-enable enable/disable
> paths as the only way to clear the soft disable flag, but the soft
> disable bit should also be cleared when removing a trigger with '!'.

Indeed, the soft-disabled flag may remain after the event itself
disabled. However that soft-disabled flag will be cleared when
the event is re-enabled. it seems no bad side-effect.

Thus I doubt this patch is separately required. I guess this is
required for adding new trigger flag, isn't it? :)

Thank you,

> 
> Also, the SOFT_DISABLED bit should never be set if SOFT_MODE is
> cleared.
> 
> This fixes the above discrepancies.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> ---
>  kernel/trace/trace_events.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index ecb2609..f9738dc 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -282,6 +282,8 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>  		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
>  		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
>  			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
> +		else
> +			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
>  		break;
>  	case 1:
>  		/*
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


