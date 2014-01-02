Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaABSmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:42:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28144 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaABSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:42:45 -0500
Date: Thu, 2 Jan 2014 13:41:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 10/18] xen/pvh: Update E820 to work with PVH (v2)
Message-ID: <20140102184133.GE3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-11-git-send-email-konrad.wilk@oracle.com>
 <52C59068.1040603@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C59068.1040603@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 04:14:32PM +0000, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > In xen_add_extra_mem() we can skip updating P2M as it's managed
> > by Xen. PVH maps the entire IO space, but only RAM pages need
> > to be repopulated.
> 
> So this looks minimal but I can't work out what PVH actually needs to do
> here.  This code really doesn't need to be made any more confusing.

I gather you prefer Mukesh's original version?

https://lkml.org/lkml/2013/12/18/710
> 
> I don't understand why the guest hasn't been supplied with sensible
> memory map that we can use as-is without playing all these games?

dom0_mem=3G,max:7G. The E820 and the P2M setup in the hypervisor have
a sensible layout (aka, 1-1). But the shared_info.nr_pages doesn't tell
us that - it instead gives us just the number of pages.

Which is OK, but if it is different than what you would expect from
the E820 (as in, the number of pages of E820_RAM is different than
the nr_pages), then you need to setup some of the E820 regions as the
balloon memory but without real memory.

Unless the hypervisor's filter out the E820 that we get through the
'XENMEM_machine_memory_map' ?

This should not be (and it did not look to be) a problem with the
E820 that is setup by the toolstack.


> 
> David
