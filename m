Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3LEIy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:54:57 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55713 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3LEIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:54:56 -0500
Date: Thu, 5 Dec 2013 09:54:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/apic: Justification for disabling IO APIC before
 Local APIC
Message-ID: <20131205085451.GA13377@gmail.com>
References: <1386202069-51515-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386202069-51515-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Since erratum AVR31 in "Intel Atom Processor C2000 Product Family
> Specification Update" is published, I add a justification comment for
> disabling IO APIC before Local APIC (commit 522e6646).
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/reboot.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index da3c599..c752cb4 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -558,6 +558,17 @@ void native_machine_shutdown(void)
>  {
>  	/* Stop the cpus and apics */
>  #ifdef CONFIG_X86_IO_APIC
> +	/*
> +	 * Disabling IO APIC before local APIC is a workaround for
> +	 * erratum AVR31 in "Intel Atom Processor C2000 Product Family
> +	 * Specification Update". In this situation, interrupts that target
> +	 * a Logical Processor whose Local APIC is either in the process of
> +	 * being hardware disabled or software disabled are neither delivered
> +	 * nor discarded. When this erratum occurs, the processor may hang.
> +	 *
> +	 * Even without the erratum, it still makes sense to quiet IO APIC
> +	 * before disabling Local APIC.
> +	 */
>  	disable_IO_APIC();
>  #endif

Looks good to me, except that patch titles should start with verbs, 
i.e. something like:

  x86/apic/doc: Add justification for disabling IO APIC before Local APIC

Which makes for a much more fluid reading of shortlogs etc.

Unless you sentences without verbs.
          ^-------------------------------------------like

;-)

Thanks,

	Ingo
