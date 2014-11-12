Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaKLRMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:12:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbaKLRMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:12:07 -0500
Message-ID: <1415812284.16601.372.camel@ul30vt.home>
Subject: Re: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
 configuration changes
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Zhang, Yang Z" <yang.z.zhang@intel.com>, "Wu, Feng" <feng.wu@intel.com>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.auger" <eric.auger@linaro.org>
Date: Wed, 12 Nov 2014 10:11:24 -0700
In-Reply-To: <546324F4.8010002@redhat.com>
References: <E959C4978C3B6342920538CF579893F00226EF05@SHSMSX104.ccr.corp.intel.com>
	 <5461EC99.1000101@redhat.com>
	 <A9667DDFB95DB7438FA9D7D576C3D87E0ABDBB25@SHSMSX104.ccr.corp.intel.com>
	 <546324F4.8010002@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 10:14 +0100, Paolo Bonzini wrote:
> 
> On 12/11/2014 04:42, Zhang, Yang Z wrote:
> > Personally, I think this feature will be helpful to the legacy device
> > assignment. Agree, vfio is the right solution for future feature
> > enabling. But the old kvm without the good vfio supporting is still
> > used largely today. The user really looking for this feature but they
> > will not upgrade their kernel. It's easy for us to backport this
> > feature to old kvm with the legacy device assignment, but it is
> > impossible to backport the whole vfio.
> 
> You can certainly backport these patches to distros that do not have
> VFIO.  But upstream we should work on VFIO first.  VFIO has feature
> parity with legacy device assignment, and adding a new feature that is
> not in VFIO would be a bad idea.

Thanks Paolo, I agree.  We should design the interfaces for VFIO since
we expect legacy KVM assignment to be deprecated and eventually removed.
I think that some of the platform device work for ARM's IRQ forwarding
should probably be leveraged for this interface.  IRQ forwarding
effectively allows level triggered interrupts to be handled as edge,
eliminating the mask/unmask overhead and EOI path entirely.  To do this
through VFIO they make use of the KVM-VFIO device to register the device
and set attributes for the forwarded IRQ.  This enables KVM to use the
VFIO external user interfaces to acquire a VFIO device reference and
access the struct device.  From there it can do some IRQ manipulation on
the device to reconfigure how the host handles the interrupt.  Ideally
we could use the same base KVM-VFIO device interface interface, perhaps
with different attributes, and obviously with different architecture
backing.  Thanks,

Alex

