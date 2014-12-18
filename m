Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaLROu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:50:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:45076 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaLROu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:50:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,601,1413270000"; 
   d="scan'208";a="656416240"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: "Wu, Feng" <feng.wu@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>
CC: "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Thread-Topic: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu()
 for VT-d PI
Thread-Index: AQHQFiCrJgBr1evklkuo8VNfnV0dX5yVdJYA
Date: Thu, 18 Dec 2014 14:49:22 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-14-git-send-email-feng.wu@intel.com>
In-Reply-To: <1418397300-10870-14-git-send-email-feng.wu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng Wu wrote on 2014-12-12:
> This patch defines a new interface kvm_find_dest_vcpu for
> VT-d PI, which can returns the destination vCPU of the
> interrupt for guests.
> 
> Since VT-d PI cannot handle broadcast/multicast interrupt,
> Here we only handle Fixed and Lowest priority interrupts.
> 
> The current method of handling guest lowest priority interrtups
> is to use a counter 'apic_arb_prio' for each vCPU, we choose the
> vCPU with smallest 'apic_arb_prio' and then increase it by 1.
> However, for VT-d PI, we cannot re-use this, since we no longer
> have control to 'apic_arb_prio' with posted interrupt direct
> delivery by Hardware.
> 
> Here, we introduce a similar way with 'apic_arb_prio' to handle guest
> lowest priority interrtups when VT-d PI is used. Here is the ideas: -
> Each vCPU has a counter 'round_robin_counter'. - When guests sets an
> interrupts to lowest priority, we choose the vCPU with smallest
> 'round_robin_counter' as the destination, then increase it.
 
How this can work well? All subsequent interrupts are delivered to one vCPU? It shouldn't be the best solution, need more consideration. Also, I think you should take the apic_arb_prio into consider since the priority is for the whole vCPU not for one interrupt.

Best regards,
Yang


