Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173Ab3IDHRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:17:20 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42931 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3IDHRT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Wed, 4 Sep 2013 03:17:19 -0400
Message-Id: <5226FA9702000078000F0387@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 04 Sep 2013 08:17:11 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: <olaf@aepfle.de>, <bp@alien8.de>, <apw@canonical.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <devel@linuxdriverproject.org>,
        <gregkh@linuxfoundation.org>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1378233023-4512-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.09.13 at 20:30, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> @@ -76,6 +80,26 @@ static void __init ms_hyperv_init_platform(void)
>  	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
>  	       ms_hyperv.features, ms_hyperv.hints);
>  
> +	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
> +		/*
> +		 * Get the APIC frequency.
> +		 */
> +		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
> +		hv_lapic_frequency /= HZ;
> +		lapic_timer_frequency = hv_lapic_frequency;
> +		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
> +				lapic_timer_frequency);
> +
> +		/*
> +		 * On Hyper-V, when we are booting off an EFI firmware stack,
> +		 * we do not have many legacy devices including PIC, PIT etc.
> +		 */
> +		if (efi_enabled(EFI_BOOT)) {
> +			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> +			legacy_pic = &null_legacy_pic;
> +		}

And this check is really connected to the feature check around the
whole block, rather than being independent? (I'd also think that
this latter message would suffice to be KERN_DEBUG).

Jan

