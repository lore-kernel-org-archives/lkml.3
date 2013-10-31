Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3JaA6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 20:58:20 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:28839 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3JaA6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 20:58:19 -0400
Date: Wed, 30 Oct 2013 18:58:13 -0600
From: jerry.hoemann@hp.com
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131031005812.GA15459@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131022220803.GA32387@anatevka.fc.hp.com>
 <526712B2.7070108@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526712B2.7070108@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:05:06AM +0900, HATAYAMA Daisuke wrote:
> >>
> >>- Rebased on top of v3.12-rc6
> >>
> >>- Basic design has been changed. Now users need to figure out initial
> >>   APIC ID of BSP in the 1st kernel and configures kernel parameter for
> >>   the 2nd kernel manually using disable_cpu_apic kernel parameter to
> >>   be newly introduced in this patch set. This design is more flexible
> >>   than the previous version in that we no longer have to rely on
> >>   ACPI/MP table to get initial APIC ID of BSP.
> >
> >
> >Do you literally mean a human at each boot will have to configure
> >the kdump configuration files for passing disable_cpu_apic?
> >Or do you envision the setting of disable_cpu_apic being put into
> >the kdump initialization scripts?
> >
> >thanks
> >
> >Jerry
> 
> Nearer to the former case, but this is not what a human should do. It's
> a cumbersome task. I think, on fedora/RHEL system for example, kdump
> service should check at each boot automatically.
> 
> HATAYAMA, Daisuke


Daisuke,

Are you planning on making changes to the kexec tools to automate
the setting of disable_cpu_apic to the capture kernel? Or do you
know someone who is planning this?

I back ported the kernel side changes to a 4.2.32 based kernel.
I tested the patch on a prototype system which exhibits a stable
initial_apic_id for CPU 0.  While not something that would be suitable
for customers, it does allow me to test the kernel portion of the patch.

I will report the results of the testing later this week.

Thanks

Jerry


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

