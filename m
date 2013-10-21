Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3JUSFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:05:00 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:29148 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3JUSE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:04:58 -0400
Date: Mon, 21 Oct 2013 12:04:53 -0600
From: jerry.hoemann@hp.com
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
Message-ID: <20131021180453.GA5225@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <20131016125104.15573.90313.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016125104.15573.90313.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:52:14PM +0900, HATAYAMA Daisuke wrote:
> This patch set is to allow kdump 2nd kernel to wake up multiple CPUs
> even if 1st kernel crashs on some AP.
> 
> Sorry, this patch set have not include in-source documentation
> requested by Borislav Petkov yet, but I'll post it later separately,
> which would be better to focus on documentation reviewing.
> 
> ChangeLog
> 
> v2 => v3)
> 
> - Change default value of boot_cpu_is_bsp to true.
> 
> - Before executing rdmsr(MSR_IA32_APICBASE), check if the number of
>   processor family is larger than or equal to 6 in order to avoid
>   invalid opcode exception on processors where MSR_IA32_APICBASE is
>   not supported.



Daisuke,

Thank you for doing this work.

I have back ported these changes to a 2.6.32 based kernel and have
tested with nr_cpus=8 and have not seen any problems.  The system
without these patches wouldn't successfully boot the capture
kernel when nr_cpus > 1.

thanks

Jerry Hoemann


> 
> v1 => v2)
> 
> - Rebased on top of v3.12-rc5.
> 
> - Fix linking time error of boot_cpu_is_bsp_init() in case of
>   CONFIG_LOCAL_APIC disabled by adding empty static inline function
>   instead.
> 
> - Fix missing feature check by means of cpu_has_apic macro in
>   boot_cpu_is_bsp_init() before calling rdmsr_safe(MSR_IA32_APICBASE).
> 
>   NOTE: I've checked local apic-present case only; I don't have any
>   x86 processor without local apic.
> 
> - Add __init annotation to boot_cpu_is_bsp_init().
> 
> Test
> 
> - built with and without CONFIG_LOCAL_APIC
> - tested x86_64 in case of acpi and MP table
> 
> ---
> 
> HATAYAMA Daisuke (2):
>       x86, apic: Add boot_cpu_is_bsp() to check if boot cpu is BSP
>       x86, apic: Disable BSP if boot cpu is AP
> 
> 
>  arch/x86/include/asm/mpspec.h |    9 ++++++++-
>  arch/x86/kernel/acpi/boot.c   |    6 +++++-
>  arch/x86/kernel/apic/apic.c   |   35 ++++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/devicetree.c  |    1 +
>  arch/x86/kernel/mpparse.c     |   15 +++++++++++++--
>  arch/x86/kernel/setup.c       |    2 ++
>  arch/x86/platform/sfi/sfi.c   |    2 +-
>  7 files changed, 64 insertions(+), 6 deletions(-)
> 
> -- 
> 
> Thanks.
> HATAYAMA, Daisuke
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

