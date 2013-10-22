Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3JVWIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:08:21 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9349 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3JVWIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:08:20 -0400
Date: Tue, 22 Oct 2013 16:08:03 -0600
From: jerry.hoemann@hp.com
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131022220803.GA32387@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 12:01:18AM +0900, HATAYAMA Daisuke wrote:
> This patch set is to allow kdump 2nd kernel to wake up multiple CPUs
> even if 1st kernel crashs on some AP, a continueing work from:
> 
>   [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
>   https://lkml.org/lkml/2013/10/16/300.
> 
> In this version, basic design has changed. Now users need to figure
> out initial APIC ID of BSP in the 1st kernel and configures kernel
> parameter for the 2nd kernel manually using disable_cpu_apic kernel
> parameter to be newly introduced in this patch set. This design is
> more flexible than the previous version in that we no longer have to
> rely on ACPI/MP table to get initial APIC ID of BSP.
> 
> Sorry, this patch set have not include in-source documentation
> requested by Borislav Petkov yet, but I'll post it later separately,
> which would be better to focus on documentation reviewing.
> 
> ChangeLog
> 
> v3 => v4)
> 
> - Rebased on top of v3.12-rc6
> 
> - Basic design has been changed. Now users need to figure out initial
>   APIC ID of BSP in the 1st kernel and configures kernel parameter for
>   the 2nd kernel manually using disable_cpu_apic kernel parameter to
>   be newly introduced in this patch set. This design is more flexible
>   than the previous version in that we no longer have to rely on
>   ACPI/MP table to get initial APIC ID of BSP.


Do you literally mean a human at each boot will have to configure
the kdump configuration files for passing disable_cpu_apic?
Or do you envision the setting of disable_cpu_apic being put into
the kdump initialization scripts?

thanks

Jerry

> 
> v2 => v3)
> 
> - Change default value of boot_cpu_is_bsp to true.
> 
> - Before executing rdmsr(MSR_IA32_APICBASE), check if the number of
>   processor family is larger than or equal to 6 in order to avoid
>   invalid opcode exception on processors where MSR_IA32_APICBASE is
>   not supported.
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
> HATAYAMA Daisuke (3):
>       x86, apic: Don't count the CPU with BP flag from MP table as booting-up CPU
>       x86, apic: Add disable_cpu_apicid kernel parameter
>       Documentation, x86, apic, kexec: Add disable_cpu_apicid kernel parameter
> 
> 
>  Documentation/kernel-parameters.txt |    9 +++++++++
>  arch/x86/kernel/apic/apic.c         |   29 +++++++++++++++++++++++++++++
>  arch/x86/kernel/mpparse.c           |    1 -
>  3 files changed, 38 insertions(+), 1 deletion(-)
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

