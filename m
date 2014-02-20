Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaBTQgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:36:06 -0500
Received: from smtp.citrix.com ([66.165.176.89]:1936 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbaBTQgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:36:04 -0500
X-IronPort-AV: E=Sophos;i="4.97,513,1389744000"; 
   d="scan'208";a="104379535"
Message-ID: <1392914159.32657.18.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is
 protected by an IOMMU
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Julien Grall <julien.grall@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "Russell King" <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>
Date: Thu, 20 Feb 2014 16:35:59 +0000
In-Reply-To: <1392913301-25524-1-git-send-email-julien.grall@linaro.org>
References: <1392913301-25524-1-git-send-email-julien.grall@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 16:21 +0000, Julien Grall wrote:
> Only Xen is able to know if a device can safely avoid to use xen-swiotlb.
> This patch introduce a new property "protected-devices" for the hypervisor
> node which list device which the IOMMU are been correctly programmed by Xen.
> 
> During Linux boot, Xen specific code will create an hash table which
> contains all these devices. The hash table will be used in need_xen_dma_ops
> to check if the Xen DMA ops needs to be used for the current device.

Is it out of the question to find a field within struct device itself to
store this e.g. in struct device_dma_parameters perhaps and avoid the
need for a hashtable lookup.

device->iommu_group might be another option, if we can create our own
group?

Ian.

