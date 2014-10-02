Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaJBAaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 20:30:46 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:55295 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaJBAao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 20:30:44 -0400
Date: Wed, 1 Oct 2014 18:30:38 -0600
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        iommu@lists.linux-foundation.org, jroedel@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] iommu/vt-d: Keep RMRR mappings around on driver
 unbind
Message-ID: <20141002003038.GA30672@anatevka.fc.hp.com>
Reply-To: Jerry.Hoemann@hp.com
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412074923-6342-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 01:02:01PM +0200, Joerg Roedel wrote:
> Hi,
> 
> here is a patch-set to fix an issue recently discovered when
> the Intel IOMMU is in use with devices that need RMRR
> mappings.
> 
> The problem is that the RMRR mappings are destroyed when the
> device driver is unbound from the device, causing DMAR
> faults.
> 
> To solve this problem a device driver core change is
> necessary to catch the right point in time for the IOMMU
> code to destroy any mappings for a device.
> 
> With this patch-set the RMRR mappings are only destroyed
> when the device is actually removed from the system.
> 
> Please review.
> 
> Thanks,
> 
> 	Joerg
> 
> Joerg Roedel (2):
>   driver core: Add BUS_NOTIFY_REMOVED_DEVICE event
>   iommu/vt-d: Only remove domain when device is removed
> 
>  drivers/base/core.c         |  3 +++
>  drivers/iommu/intel-iommu.c | 11 +----------
>  include/linux/device.h      | 11 ++++++-----
>  3 files changed, 10 insertions(+), 15 deletions(-)
> 
> -- 
> 1.9.1


Joerg,

I tested on HP Gen7 and Gen9 systems for which we experience dmar faults
when we rmmod a driver whose device had RMRR regions associated with it.

We don't see problem when patch set is applied.

Thanks,

Tested-by: Jerry Hoemann <jerry.hoemann@hp.com>

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 36                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-0707
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

