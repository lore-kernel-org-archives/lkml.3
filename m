Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3F1Snd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab3F1Snc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:43:32 -0400
Message-ID: <1372445006.30572.772.camel@ul30vt.home>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 12:43:26 -0600
In-Reply-To: <20130628182946.GU11309@8bytes.org>
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it>
	 <20130628181136.52d00e9c@dualc.maya.org>
	 <1372441744.30572.765.camel@ul30vt.home>
	 <20130628182946.GU11309@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 20:29 +0200, Joerg Roedel wrote:
> Hi Alex,
> 
> On Fri, Jun 28, 2013 at 11:49:04AM -0600, Alex Williamson wrote:
> > That's interesting, I PXE boot my system from one NIC then use a
> > different NIC for the iSCSI root.  The PXE boot NIC now screams like
> > this, _until_ I attach it to vfio, then it quiets down.
> 
> Can you please send an example line of the reported fault? The addresses
> it faults on would be interesting.

[   99.613489] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0
domain=0x0000 address=0x000000000008f880 flags=0x0050]

> > > Any idea?
> > 
> > Not really without some digging.  I wonder if it's a new event each time
> > or if something is just not clearing a previous event.  ISTR that a boot
> > used to often, but not always, generate a couple faults between the
> > IOMMU being enabled and the NIC driver being loaded.  All the faults I
> > see are to the same address, so my guess is that it's getting replayed.
> 
> Well, I think it is a problem uncovered by the patch that re-enables the
> event-log interrupt after it happened once. We need to find a strategy
> to cope with those problems.
> 
> To my mind as a quick-fix comes rate-limiting for the printks. Or we use
> the suppress-pf bit in the DTE to suppress all page-faults after the
> first one.
> 
> 
> 	Joerg
> 
> 



