Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3I0PKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:10:42 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:45844 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3I0PKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:10:40 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rHSweG2GBQ=
X-RZG-CLASS-ID: mo00
Date: Fri, 27 Sep 2013 17:10:26 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        tglx@linutronix.de, hpa@zytor.com, JBeulich@suse.com, bp@alien8.de
Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Message-ID: <20130927151026.GA29416@aepfle.de>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1378233023-4512-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, K. Y. Srinivasan wrote:

> Hyper-V supports a mechanism for retrieving the local APIC frequency.Use this and bypass
> the calibration code in the kernel. This would allow us to boot the Linux kernel as a
> "modern VM" on Hyper-V where many of the legacy devices (such as PIT) are not emulated.

> +	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
> +		/*
> +		 * Get the APIC frequency.
> +		 */
> +		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
> +		hv_lapic_frequency /= HZ;

This leads to build errors on 32bit:

linux-3.12-rc2/arch/x86/kernel/cpu/mshyperv.c:88: undefined reference to `__udivdi3'

Up to now I have only tested on 64bit, sorry for that.


Olaf
