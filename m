Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaBXMTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:19:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:11138 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaBXMTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:19:18 -0500
X-IronPort-AV: E=Sophos;i="4.97,534,1389744000"; 
   d="scan'208";a="103507957"
Date: Mon, 24 Feb 2014 12:19:11 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is
 protected by an IOMMU
In-Reply-To: <1392914159.32657.18.camel@kazak.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1402241214570.4471@kaball.uk.xensource.com>
References: <1392913301-25524-1-git-send-email-julien.grall@linaro.org> <1392914159.32657.18.camel@kazak.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Greg.

On Thu, 20 Feb 2014, Ian Campbell wrote:
> On Thu, 2014-02-20 at 16:21 +0000, Julien Grall wrote:
> > Only Xen is able to know if a device can safely avoid to use xen-swiotlb.
> > This patch introduce a new property "protected-devices" for the hypervisor
> > node which list device which the IOMMU are been correctly programmed by Xen.
> > 
> > During Linux boot, Xen specific code will create an hash table which
> > contains all these devices. The hash table will be used in need_xen_dma_ops
> > to check if the Xen DMA ops needs to be used for the current device.
> 
> Is it out of the question to find a field within struct device itself to
> store this e.g. in struct device_dma_parameters perhaps and avoid the
> need for a hashtable lookup.
> 
> device->iommu_group might be another option, if we can create our own
> group?

I agree that a field in struct device would be ideal.
Greg, get_maintainer.pl points at you as main maintainer of device.h, do
you have an opinion on this?
