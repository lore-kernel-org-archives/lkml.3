Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaKFMyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:54:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaKFMyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:54:09 -0500
Date: Thu, 6 Nov 2014 13:54:05 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Myron Stowe <mstowe@redhat.com>
Subject: Re: [PATCH 2/2] iommu/vt-d: Only remove domain when device is removed
Message-ID: <20141106125405.GI8354@suse.de>
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
 <1412074923-6342-3-git-send-email-joro@8bytes.org>
 <1415117537.27420.428.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415117537.27420.428.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Tue, Nov 04, 2014 at 09:12:17AM -0700, Alex Williamson wrote:
> I haven't tested it, but I'm concerned whether this has introduced a
> domain leak.  If we think about the case of unbinding a device from a
> host driver and attaching it to a domain through the IOMMU API, I think
> we used to count on this path to call domain_exit(), which made the
> domain_context_mapped() in intel_iommu_attach_device() "unlikely".  With
> this change, isn't the test in intel_iommu_attach_device() now neither
> likely nor unlikely and we're only removing the dev_info from the domain
> and not destroying the domain itself?  Thanks,

As I see it, there is no leak. The DMA-API domains are kept in the
device_domain_list and re-used when the device driver re-attaches. But
your are right that the unlikely in intel_iommu_attach_device() isn't
true anymore. We could probably remove it.


	Joerg

