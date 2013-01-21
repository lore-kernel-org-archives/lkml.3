Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3AULjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:39:16 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48962 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3AULjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:39:12 -0500
X-AuditID: 85900ec0-d7c7db900000152f-c4-50fd28dd2deb
Message-ID: <50FD28CD.7070108@hitachi.com>
Date: Mon, 21 Jan 2013 20:38:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, jbaron@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 4/5] alternatives: constify alternatives_text_reserved
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com> <1357772960-4436-4-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1357772960-4436-4-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/10 8:09), Sasha Levin wrote:
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

This looks good for me. And, please add a comment to explain
what this patch is for.

Thank you,

> ---
>  arch/x86/include/asm/alternative.h | 4 ++--
>  arch/x86/kernel/alternative.c      | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index 58ed6d9..4d0d2fb 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -61,7 +61,7 @@ extern void alternatives_smp_module_add(struct module *mod, char *name,
>  					void *text, void *text_end);
>  extern void alternatives_smp_module_del(struct module *mod);
>  extern void alternatives_enable_smp(void);
> -extern int alternatives_text_reserved(void *start, void *end);
> +extern int alternatives_text_reserved(const void *start, const void *end);
>  extern bool skip_smp_alternatives;
>  #else
>  static inline void alternatives_smp_module_add(struct module *mod, char *name,
> @@ -69,7 +69,7 @@ static inline void alternatives_smp_module_add(struct module *mod, char *name,
>  					       void *text, void *text_end) {}
>  static inline void alternatives_smp_module_del(struct module *mod) {}
>  static inline void alternatives_enable_smp(void) {}
> -static inline int alternatives_text_reserved(void *start, void *end)
> +static inline int alternatives_text_reserved(const void *start, const void *end)
>  {
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index ef5ccca..0994e41 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -431,12 +431,12 @@ void alternatives_enable_smp(void)
>  }
>  
>  /* Return 1 if the address range is reserved for smp-alternatives */
> -int alternatives_text_reserved(void *start, void *end)
> +int alternatives_text_reserved(const void *start, const void *end)
>  {
>  	struct smp_alt_module *mod;
>  	const s32 *poff;
> -	u8 *text_start = start;
> -	u8 *text_end = end;
> +	const u8 *text_start = start;
> +	const u8 *text_end = end;
>  
>  	list_for_each_entry(mod, &smp_alt_modules, next) {
>  		if (mod->text > text_end || mod->text_end < text_start)
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


