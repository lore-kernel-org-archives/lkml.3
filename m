Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbaHGGR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:17:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:43497 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbaHGGR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:17:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,816,1400050800"; 
   d="scan'208";a="584580687"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
Thread-Topic: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
Thread-Index: AQHPrBEkMevXzPHWyEW1NdRMjvzN+JvDpASg//99kwCAAT84cP//zlYAgACHHfA=
Date: Thu, 7 Aug 2014 06:17:53 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB52909@SHSMSX104.ccr.corp.intel.com>
References: <1406736728-8516-1-git-send-email-pbonzini@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB51BA1@SHSMSX104.ccr.corp.intel.com>
 <53E236E6.6050206@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB5264D@SHSMSX104.ccr.corp.intel.com>
 <53E31904.9040909@redhat.com>
In-Reply-To: <53E31904.9040909@redhat.com>
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

Paolo Bonzini wrote on 2014-08-07:
> Il 07/08/2014 03:31, Zhang, Yang Z ha scritto:
>> Let me give an example to see whether my concern is a real problem:
>> Guest allocates a vector and set it in IOAPIC entry to deliver
>> interrupt. Later it masks the IOAPIC entry(means stop the
>> corresponding device) and assign this vector to a MSI device. With
>> this patch, even the vector is not used by IOAPIC, but it still set
>> eoi exit bitmap unconditionally. The subsequent EOIs to MSI device
>> will force vmexit. Could this happen?
> 
> Yes, I guess it could.  I'm not sure whether it could on Linux or Windows.
> 
>> I think the right fixing is to check the ISR plus TMR to construct
>> the eoi exit bitmap.
> 
> Do you care enough to propose a patch? :)
> 

Sure. I will do it.

> Paolo


Best regards,
Yang

