Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab3JRG3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:29:13 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53882 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3JRG3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:29:11 -0400
Date: Fri, 18 Oct 2013 08:29:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>, John Stultz <john.stultz@linaro.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: honor ACPI FADT flag indicating absence of a CMOS
 RTC
Message-ID: <20131018062908.GD14264@gmail.com>
References: <525E969E02000078000FB710@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525E969E02000078000FB710@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> We shouldn't be creating a corresponding platform device in that case.

There's a sad lack of context in the changelog, how was it found, does 
this address any problem/bug observed in practice, etc?

> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  arch/x86/kernel/rtc.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- 3.12-rc5/arch/x86/kernel/rtc.c
> +++ 3.12-rc5-x86-ACPI-no-RTC/arch/x86/kernel/rtc.c
> @@ -192,6 +192,11 @@ static __init int add_rtc_cmos(void)
>  	if (mrst_identify_cpu())
>  		return -ENODEV;
>  
> +#ifdef CONFIG_ACPI
> +	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
> +		return -ENODEV;
> +#endif

It might also be prudent to emit a KERN_INFO line telling that we don't 
create the device - so that people who suddenly see unexpected breakage or 
change in behavior have a chance to see what we've done?

Thanks,

	Ingo
