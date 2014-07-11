Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaGKQ2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:28:09 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:23847 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaGKQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:28:05 -0400
Date: Fri, 11 Jul 2014 10:27:45 -0600
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: David Woodhouse <dwmw2@infradead.org>, indou.takao@jp.fujitsu.com,
        bhe@redhat.com, linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, zhenhua@hp.com
Subject: Re: [PATCH 0/8] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20140711162745.GA8335@anatevka.fc.hp.com>
Reply-To: Jerry.Hoemann@hp.com
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
 <1398854973.12733.23.camel@i7.infradead.org>
 <20140702133258.GN26537@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702133258.GN26537@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 03:32:59PM +0200, Joerg Roedel wrote:
> Hi David,
> 
> On Wed, Apr 30, 2014 at 11:49:33AM +0100, David Woodhouse wrote:
> > There could be all kinds of existing mappings in the DMA page tables,
> > and I'm not sure it's safe to preserve them. What prevents the crashdump
> > kernel from trying to use any of the physical pages which are
> > accessible, and which could thus be corrupted by stray DMA?
> > 
> > In fact, the old kernel could even have set up 1:1 passthrough mappings
> > for some devices, which would then be able to DMA *anywhere*. Surely we
> > need to prevent that?
> 
> Ideally we would prevent that, yes. But the problem is that a failed DMA
> transaction might put the device into an unrecoverable state. Usually
> any in-flight DMA transactions should only target buffers set up by the
> previous kernel and not corrupt any data.
> 
> > After the last round of this patchset, we discussed a potential
> > improvement where you point every virtual bus address at the *same*
> > physical scratch page.
> 
> That is a solution to prevent the in-flight DMA failures. But what
> happens when there is some in-flight DMA to a disk to write some inodes
> or a new superblock. Then this scratch address-space may cause
> filesystem corruption at worst.
> 
> So with this in mind I would prefer initially taking over the
> page-tables from the old kernel before the device drivers re-initialize
> the devices.
> 
> 
> 	Joerg

David, Joerg,

What do you think here?  Do you want me to update the patch set for 3.17?

Jerry

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

