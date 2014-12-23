Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaLWAiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:38:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:27764 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaLWAiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:38:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,627,1413270000"; 
   d="scan'208";a="651905629"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "Wu, Feng" <feng.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "Gleb Natapov" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: RE: [v3 06/26] iommu, x86: No need to migrating irq for VT-d
 Posted-Interrupts
Thread-Topic: [v3 06/26] iommu, x86: No need to migrating irq for VT-d
 Posted-Interrupts
Thread-Index: AQHQFiFw/2wcwNXVUk6mLzPIG8E78JyVcJswgAC8KvCAAAEAoIAAJl0AgAYPrcA=
Date: Tue, 23 Dec 2014 00:37:46 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC06282@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-7-git-send-email-feng.wu@intel.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC0486D@SHSMSX104.ccr.corp.intel.com>
	<E959C4978C3B6342920538CF579893F00230A649@SHSMSX104.ccr.corp.intel.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC04E77@SHSMSX104.ccr.corp.intel.com>
 <54941326.4080405@redhat.com>
In-Reply-To: <54941326.4080405@redhat.com>
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

Paolo Bonzini wrote on 2014-12-19:
> 
> 
> On 19/12/2014 02:46, Zhang, Yang Z wrote:
>>> If the IRQ is posted, its affinity is controlled by guest (irq
>>> <---> vCPU <----> pCPU), it has no effect when host changes its affinity.
>> 
>> That's the problem: User is able to changes it in host but it never
>> takes effect since it is actually controlled by guest. I guess it
>> will break the IRQ balance too.
> 
> I don't think that's a problem.
> 
> Controlling the affinity in the host affects which CPU in the host
> takes care of signaling the guest.
> 
> If this signaling is done directly by the chipset, there is no need to
> do anything in the host and thus the host affinity can be bypassed.

I don't quite understand it. If user set an interrupt's affinity to a CPU, but he still see the interrupt delivers to other CPUs in host. Do you think it is a right behavior?

> 
> Paolo


Best regards,
Yang

