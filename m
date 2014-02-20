Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaBTRN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:13:27 -0500
Received: from smtp.citrix.com ([66.165.176.89]:63333 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbaBTRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:13:25 -0500
X-IronPort-AV: E=Sophos;i="4.97,513,1389744000"; 
   d="scan'208";a="104396292"
Message-ID: <1392916401.32657.31.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is
 protected by an IOMMU
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Julien Grall <julien.grall@linaro.org>, <devicetree-spec@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>, "Rob Herring" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "Russell King" <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>
Date: Thu, 20 Feb 2014 17:13:21 +0000
In-Reply-To: <1392913301-25524-1-git-send-email-julien.grall@linaro.org>
References: <1392913301-25524-1-git-send-email-julien.grall@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the -spec list for the generic IOMMU binding question.

On Thu, 2014-02-20 at 16:21 +0000, Julien Grall wrote:
> diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> index 0f7b9c2..ee25a57 100644
> --- a/Documentation/devicetree/bindings/arm/xen.txt
> +++ b/Documentation/devicetree/bindings/arm/xen.txt
> @@ -15,6 +15,8 @@ the following properties:
>  - interrupts: the interrupt used by Xen to inject event notifications.
>    A GIC node is also required.
>  
> +- protected-devices: (optional) List of phandles to device node where the
> +IOMMU has been programmed by Xen. 

Is there some common/generic IOMMU binding which we can reuse here?
Although this isn't exactly an IOMMU it certainly has some similarities
-- it is providing IOMMU like functionality (albeit a very inflexible
IOMMU which you don't need to/can't actually program).

I'd far rather we followed existing patterns rather than invent our own
things.

I'm wondering if perhaps we didn't ought to integrate this as an actual
IOMMU driver, although I'm not convinced this would make sense.

I'm also not sure about shovelling everything as properties under a
single Xen node, should this not be its own node with compatible =
"xen,(pv)iommu"?

Ian.

