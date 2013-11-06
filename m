Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3KFTCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:02:40 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:14607 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3KFTCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:02:39 -0500
Date: Wed, 6 Nov 2013 12:02:32 -0700
From: jerry.hoemann@hp.com
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131106190232.GA28119@anatevka.fc.hp.com>
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
> 


Daisuke,

I have back ported version 4 of this patch to both a 2.6.32 and 3.0.80
based kernels and distros and tested on a prototype system.  I have
previously test version 1 & 3 as well.)

The systems are configured to boot the capture kernel 8-way parallel.
However, I am running makedumpfile single threaded.

Panic is induced via "echo c > /proc/sysrq-trigger".  This is done
under various system loads and on random cpus.  I have done over a
thousand dumps total during this testing.

I have seen no issues w/ the 3.0.80 dump testing on our proto.

On the 2.6.32 testing on our proto, i have hit a low probability (< 5%)
chance of the capture suffering a soft lockup hang during
"Switching to clocksource hpet."  I have not RCA'd this yet.
Note, I have seen this issue on earlier version of the patch, so
it is not specific to this version.

I then tested the 2.6.32 port on a dl380.  This worked without issue.

Note, I have seen no issues related to this patch on our proto when
booting the capture with a single processor.

While I am still pursuing the issue of the 2.6.32 kernel on our proto,
I believe this patch is good and should be accepted.




thanks

Jerry

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

