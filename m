Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3KNBUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:20:49 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34227 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3KNBUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:20:39 -0500
Message-ID: <52842564.4040305@hitachi.com>
Date: Thu, 14 Nov 2013 10:20:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/13] kprobes: Remove uneeded kernel dependency
 on struct arch_specific_insn
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-11-git-send-email-dave.long@linaro.org>
In-Reply-To: <1381871068-27660-11-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/16 6:04), David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Instead of depending on include/asm/kprobes.h to provide a dummy definition
> for struct arch_specific_insn, do so in include/linux/kprobes.h.

Nak, why do we need ugly #ifdef again there?
And also, please cc to the original maintainers.

Thank you,

> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  include/linux/kprobes.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 925eaf2..4b5a74d 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -52,9 +52,6 @@
>  
>  #else /* CONFIG_KPROBES */
>  typedef int kprobe_opcode_t;
> -struct arch_specific_insn {
> -	int dummy;
> -};
>  #endif /* CONFIG_KPROBES */
>  
>  struct kprobe;
> @@ -110,7 +107,11 @@ struct kprobe {
>  	kprobe_opcode_t opcode;
>  
>  	/* copy of the original instruction */
> +#ifdef CONFIG_KPROBES
>  	struct arch_specific_insn ainsn;
> +#else
> +	int ainsn;
> +#endif
>  
>  	/*
>  	 * Indicates various status flags.
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


