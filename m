Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbALMw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:52:56 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58665 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbbALMwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:52:55 -0500
Message-ID: <54B3C3A0.6010708@hitachi.com>
Date: Mon, 12 Jan 2015 21:52:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lizefan@huawei.com
Subject: Re: [PATCH] kprobes: bugfix: checks kprobes_all_disarmed in unoptimized_kprobe().
References: <54B3B32E.7070709@hitachi.com> <1421064563-77831-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1421064563-77831-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/12 21:09), Wang Nan wrote:
> Original code failed to disarm the probed instruction after
> 
> echo 0 > /sys/kernel/debug/kprobes/enabled
> 
> if OPTPROBE is enabled.
> 
> This patch checks kprobes_all_disarmed in unoptimized_kprobe().
> 

Looks good :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  kernel/kprobes.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 9471710..f16936b 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -630,6 +630,9 @@ static void unoptimize_kprobe(struct kprobe *p, bool force)
>  {
>  	struct optimized_kprobe *op;
>  
> +	if (kprobes_all_disarmed)
> +		return;
> +
>  	if (!kprobe_aggrprobe(p) || kprobe_disarmed(p))
>  		return; /* This is not an optprobe nor optimized */
>  
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


