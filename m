Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaKLJPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:15:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaKLJPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:15:13 -0500
Message-ID: <546324F4.8010002@redhat.com>
Date: Wed, 12 Nov 2014 10:14:28 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>, "Wu, Feng" <feng.wu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/13] KVM: Update IRTE according to guest interrupt configuration
 changes
References: <E959C4978C3B6342920538CF579893F00226EF05@SHSMSX104.ccr.corp.intel.com> <5461EC99.1000101@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0ABDBB25@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0ABDBB25@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/11/2014 04:42, Zhang, Yang Z wrote:
> Personally, I think this feature will be helpful to the legacy device
> assignment. Agree, vfio is the right solution for future feature
> enabling. But the old kvm without the good vfio supporting is still
> used largely today. The user really looking for this feature but they
> will not upgrade their kernel. It's easy for us to backport this
> feature to old kvm with the legacy device assignment, but it is
> impossible to backport the whole vfio.

You can certainly backport these patches to distros that do not have
VFIO.  But upstream we should work on VFIO first.  VFIO has feature
parity with legacy device assignment, and adding a new feature that is
not in VFIO would be a bad idea.

By the way, do you have benchmark results for it?  We have not been able
to see any performance improvement for APICv on e.g. netperf.

Paolo
