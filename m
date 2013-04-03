Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958Ab3DCSBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759491Ab3DCSBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:01:45 -0400
Message-ID: <1365012091.2882.252.camel@bling.home>
Subject: Re: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Varun Sethi <Varun.Sethi@freescale.com>, stuart.yoder@freescale.com,
        scottwood@freescale.com, iommu@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        galak@kernel.crashing.org, benh@kernel.crashing.org
Date: Wed, 03 Apr 2013 12:01:31 -0600
In-Reply-To: <20130402161812.GI15687@8bytes.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
	 <1364500442-20927-6-git-send-email-Varun.Sethi@freescale.com>
	 <20130402161812.GI15687@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 18:18 +0200, Joerg Roedel wrote:
> Cc'ing Alex Williamson
> 
> Alex, can you please review the iommu-group part of this patch?

Sure, it looks pretty reasonable.  AIUI, all PCI devices are below some
kind of host bridge that is either new and supports partitioning or old
and doesn't.  I don't know if that's a visibility or isolation
requirement, perhaps PCI ACS-ish.  In the new host bridge case, each
device gets a group.  This seems not to have any quirks for
multifunction devices though.  On AMD and Intel IOMMUs we test
multifunction device ACS support to determine whether all the functions
should be in the same group.  Is there any reason to trust multifunction
devices on PAMU?

I also find it curious what happens to the iommu group of the host
bridge.  In the partitionable case the host bridge group is removed, in
the non-partitionable case the host bridge group becomes the group for
the children, removing the host bridge.  It's unique to PAMU so far that
these host bridges are even in an iommu group (x86 only adds pci
devices), but I don't see it as necessarily wrong leaving it in either
scenario.  Does it solve some problem to remove them from the groups?
Thanks,

Alex

