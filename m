Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbbA2KCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:02:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:24232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035AbbA2JCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,485,1418112000"; 
   d="scan'208";a="644377745"
From: "Wu, Feng" <feng.wu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 08/26] iommu, x86: Add intel_irq_remapping_capability() for
 Intel
Thread-Topic: [v3 08/26] iommu, x86: Add intel_irq_remapping_capability()
 for Intel
Thread-Index: AQHQOxByI31ejjIomkibqdBFW7WQ7ZzWxs2A
Date: Thu, 29 Jan 2015 08:57:54 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0023896B8@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	 <1418397300-10870-9-git-send-email-feng.wu@intel.com>
 <1422459450.5293.62.camel@infradead.org>
In-Reply-To: <1422459450.5293.62.camel@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0TA2GMA014621



> -----Original Message-----
> From: David Woodhouse [mailto:dwmw2@infradead.org]
> Sent: Wednesday, January 28, 2015 11:38 PM
> To: Wu, Feng
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> gleb@kernel.org; pbonzini@redhat.com; joro@8bytes.org;
> alex.williamson@redhat.com; jiang.liu@linux.intel.com; eric.auger@linaro.org;
> linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org
> Subject: Re: [v3 08/26] iommu, x86: Add intel_irq_remapping_capability() for
> Intel
> 
> On Fri, 2014-12-12 at 23:14 +0800, Feng Wu wrote:
> > Add the Intel side implementation for capability in
> > struct irq_remap_ops.
> >
> > Signed-off-by: Feng Wu <feng.wu@intel.com>
> > Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
> 
> > +static bool intel_irq_remapping_capability(enum irq_remap_cap cap)
> > +{
> > +	struct dmar_drhd_unit *drhd;
> > +	struct intel_iommu *iommu;
> > +
> > +	switch (cap) {
> > +	case IRQ_POSTING_CAP:
> > +		/*
> > +		 * If 1) posted-interrupts is disabled by user
> > +		 * or 2) irq remapping is disabled, posted-interrupts
> > +		 * is not supported.
> > +		 */
> > +		if (disable_irq_post || !irq_remapping_enabled)
> > +			return 0;
> > +
> > +		for_each_iommu(iommu, drhd)
> > +			if (!cap_pi_support(iommu->cap))
> > +				return 0;
> > +
> 
> If a new IOMMU is hotplugged now which doesn't support posted
> interrupts, what happens?

Good question, Just had a offline discussion with Jiang Liu, actually, there
is the same question for IR. In the current implementation, If IR is in use
and a new IOMMU without IR capability is hotplugged, it will reject this
hotplugging. I think I can simple follow the same policy for PI.

Thanks,
Feng

> 
> --
> David Woodhouse                            Open Source Technology
> Centre
> David.Woodhouse@intel.com                              Intel
> Corporation
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
