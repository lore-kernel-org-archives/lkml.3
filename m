Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaABTOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:14:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38748 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaABTOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:14:03 -0500
Date: Thu, 2 Jan 2014 14:12:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Subject: Re: [PATCH v12] Linux Xen PVH support.
Message-ID: <20140102191250.GI3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <52C5B266.1090009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C5B266.1090009@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 10:39:34AM -0800, H. Peter Anvin wrote:
> On 12/31/2013 08:35 PM, Konrad Rzeszutek Wilk wrote:
> > The patches, also available at
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v12
> > 
> > implements the neccessary functionality to boot a PV guest in PVH mode.
> > 
> 
> As x86 maintainer I would like to see a list of what pvops are necessary
> in PVH mode.  Obviously the hope is that the really invasive ones will

This patchset uses these
+               pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
+               pv_cpu_ops.cpuid = xen_cpuid;

These are still in the code:

 	pv_info = xen_info;
        pv_init_ops = xen_init_ops;
	pv_apic_ops = xen_apic_ops;
	pv_time_ops = xen_time_ops;

And the x86_init,apic, and smp_ops ops are still in force.

This is just the first step so there might be some other ones
that are needed that I failed to enumerate.

We are at the infancy period.

> not be necessary (and there are good reasons to believe that is within
> reach.)
> 
> 	-hpa
> 
> 
