Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbbAVWwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:52:09 -0500
Received: from outbound-smtp03.blacknight.com ([81.17.249.16]:40560 "EHLO
	outbound-smtp03.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbbAVWwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:52:08 -0500
Message-ID: <54C17F15.1070404@nexus-software.ie>
Date: Thu, 22 Jan 2015 22:52:05 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
References: <1421960036-7019-1-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1501222230180.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501222230180.5526@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 21:42, Thomas Gleixner wrote:
>   config X86_UP_APIC
>   	bool "Local APIC support on uniprocessors"
> -	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
> +	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
>   	---help---
>   	  A local APIC (Advanced Programmable Interrupt Controller) is an
>   	  integrated interrupt controller in the CPU. If you have a single-CPU
> @@ -872,6 +872,10 @@ config X86_UP_APIC
>   	  performance counters), and the NMI watchdog which detects hard
>   	  lockups.
>
> +config X86_UP_APIC_MSI
> +	def_bool y
> +	select X86_UP_APIC if X86_32 && !SMP && !X86_32_NON_STANDARD && PCI_MSI
> +
>   config X86_UP_IOAPIC
>   	bool "IO-APIC support on uniprocessors"
>   	depends on X86_UP_APIC

OK.

That works.

You can select local apic and/or io-apic on X86_32 individually with 
PCI_MSI swiched off.

If you switch on PCI_MSI the option for X86_UP_APIC_MSI disappears from 
and is silently selected by X86_UP_APIC_MSI.




