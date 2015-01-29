Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbbA2H5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:57:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:6797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbbA2H51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:57:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,485,1418112000"; 
   d="scan'208";a="644354260"
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
Subject: RE: [v3 04/26] iommu, x86: Implement irq_set_vcpu_affinity for
 intel_ir_chip
Thread-Topic: [v3 04/26] iommu, x86: Implement irq_set_vcpu_affinity for
 intel_ir_chip
Thread-Index: AQHQOw7n+cqifiI3OkG6fA2rvlodZ5zWuayg
Date: Thu, 29 Jan 2015 07:55:24 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002389312@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	 <1418397300-10870-5-git-send-email-feng.wu@intel.com>
 <1422458811.5293.56.camel@infradead.org>
In-Reply-To: <1422458811.5293.56.camel@infradead.org>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0T7vZAh012715



> -----Original Message-----
> From: David Woodhouse [mailto:dwmw2@infradead.org]
> Sent: Wednesday, January 28, 2015 11:27 PM
> To: Wu, Feng
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> gleb@kernel.org; pbonzini@redhat.com; joro@8bytes.org;
> alex.williamson@redhat.com; jiang.liu@linux.intel.com; eric.auger@linaro.org;
> linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org
> Subject: Re: [v3 04/26] iommu, x86: Implement irq_set_vcpu_affinity for
> intel_ir_chip
> 
> On Fri, 2014-12-12 at 23:14 +0800, Feng Wu wrote:
> > Implement irq_set_vcpu_affinity for intel_ir_chip.
> >
> > Signed-off-by: Feng Wu <feng.wu@intel.com>
> > Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
> 
> Acked-by: David.Woodhouse <David.Woodhouse@intel.com> assuming a
> suitable answer to...
> 
> > +		vcpu_pi_info = (struct vcpu_data *)vcpu_info;
> > +		memcpy(irte_pi, &ir_data->irte_entry, sizeof(struct irte));
> > +
> > +		irte_pi->urg = 0;
> > +		irte_pi->vector = vcpu_pi_info->vector;
> > +		irte_pi->pda_l = (vcpu_pi_info->pi_desc_addr >>
> > +				 (32 - PDA_LOW_BIT)) & ~(-1UL << PDA_LOW_BIT);
> > +		irte_pi->pda_h = (vcpu_pi_info->pi_desc_addr >> 32) &
> > +				 ~(-1UL << PDA_HIGH_BIT);
> > +
> > +		irte_pi->__reserved_1 = 0;
> > +		irte_pi->__reserved_2 = 0;
> > +		irte_pi->__reserved_3 = 0;
> > +		irte_pi->__reserved_4 = 0;
> 
> .... do we need a barrier here before we set this bit?

Thanks a lot for your Ack, David!

I cannot find a reason why we need a barrier here, since 'irte_pi' is only a local
variant here, the real operation to program hardware occurs in modify_irte(), in
which spin lock is acquired, this means the there is an implicit barrier there.

Thanks,
Feng

> 
> > +		irte_pi->pst = 1;
> > +
> > +		modify_irte(&ir_data->irq_2_iommu, (struct irte *)irte_pi);
> 
> 
> --
> dwmw2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
