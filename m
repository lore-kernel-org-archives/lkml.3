Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaBXPNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:13:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaBXPNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:13:47 -0500
Date: Mon, 24 Feb 2014 07:16:36 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Julien Grall <julien.grall@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is
 protected by an IOMMU
Message-ID: <20140224151636.GA13489@kroah.com>
References: <1392913301-25524-1-git-send-email-julien.grall@linaro.org>
 <1392914159.32657.18.camel@kazak.uk.xensource.com>
 <alpine.DEB.2.02.1402241214570.4471@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402241214570.4471@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 12:19:11PM +0000, Stefano Stabellini wrote:
> CC'ing Greg.
> 
> On Thu, 20 Feb 2014, Ian Campbell wrote:
> > On Thu, 2014-02-20 at 16:21 +0000, Julien Grall wrote:
> > > Only Xen is able to know if a device can safely avoid to use xen-swiotlb.
> > > This patch introduce a new property "protected-devices" for the hypervisor
> > > node which list device which the IOMMU are been correctly programmed by Xen.
> > > 
> > > During Linux boot, Xen specific code will create an hash table which
> > > contains all these devices. The hash table will be used in need_xen_dma_ops
> > > to check if the Xen DMA ops needs to be used for the current device.
> > 
> > Is it out of the question to find a field within struct device itself to
> > store this e.g. in struct device_dma_parameters perhaps and avoid the
> > need for a hashtable lookup.
> > 
> > device->iommu_group might be another option, if we can create our own
> > group?
> 
> I agree that a field in struct device would be ideal.
> Greg, get_maintainer.pl points at you as main maintainer of device.h, do
> you have an opinion on this?

I need a whole lot more context here please.  With a patch would be even
better so that I know exactly what you are referring to...
