Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaJAWfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:35:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaJAWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:35:11 -0400
Date: Wed, 1 Oct 2014 15:35:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        jroedel@suse.de
Subject: Re: [PATCH 0/2] iommu/vt-d: Keep RMRR mappings around on driver
 unbind
Message-ID: <20141001223510.GB12989@kroah.com>
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

I have no objection to these, do you want me to take them through my
tree?  Or if they are going through some other one feel free to add:

	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

To the first patch.

thanks,

greg k-h
