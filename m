Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab3LLFrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:47:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:6909 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3LLFrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,876,1378882800"; 
   d="scan'208";a="448766657"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: RE: [PATCH v2 0/4] X86/KVM: enable Intel MPX for KVM
Thread-Topic: [PATCH v2 0/4] X86/KVM: enable Intel MPX for KVM
Thread-Index: AQHO9lbMf+S7r+6fxkeY+guSVvGgeppQC9bA
Date: Thu, 12 Dec 2013 05:47:07 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233501421D73@SHSMSX101.ccr.corp.intel.com>
References: <1386394315-48984-1-git-send-email-jinsong.liu@intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350141B4A7@SHSMSX101.ccr.corp.intel.com>
 <52A83606.40908@redhat.com>
In-Reply-To: <52A83606.40908@redhat.com>
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

Paolo Bonzini wrote:
> Il 11/12/2013 09:31, Liu, Jinsong ha scritto:
>> Paolo, comments for version 2?
> 
> I think I commented that it's fine, I'm just waiting for a rebase on
> top of the generic patches.
> 
> Paolo
> 

Thanks! common MPX definiation patches have been checked in tip tree (both Qiaowei and I use that definiations):
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=191f57c137bcce0e3e9313acb77b2f114d15afbb
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=e7d820a5e549b3eb6c3f9467507566565646a669

Jinsong

>> 
>> Liu, Jinsong wrote:
>>> These patches are version 2 to enalbe Intel MPX for KVM.
>>> 
>>> Version 1:
>>>   * Add some Intel MPX definiation
>>>   * Fix a cpuid(0x0d, 0) exposing bug, dynamic per XCR0 features
>>> enable/disable 
>>>   * vmx and msr handle for MPX support at KVM
>>>   * enalbe MPX feature for guest
>>> 
>>> Version 2:
>>>   * remove generic MPX definiation, kernel side has add the
>>> definiation 
>>>   * add MSR_IA32_BNDCFGS to msrs_to_save
>>> 
>>> Thanks,
>>> Jinsong
>>> 
>>> Liu Jinsong (4):
>>>   KVM/X86: Fix xsave cpuid exposing bug
>>>   KVM/X86: Intel MPX vmx and msr handle
>>>   KVM/X86: add MSR_IA32_BNDCFGS to msrs_to_save
>>>   KVM/X86: Enable Intel MPX for guest.
>>> 
>>>  arch/x86/include/asm/vmx.h            |    4 ++++
>>>  arch/x86/include/asm/xsave.h          |    2 ++
>>>  arch/x86/include/uapi/asm/msr-index.h |    1 +
>>>  arch/x86/kvm/cpuid.c                  |    8 ++++----
>>>  arch/x86/kvm/vmx.c                    |   18 ++++++++++++++++--
>>>  arch/x86/kvm/x86.c                    |   12 +++++++++---
>>>  arch/x86/kvm/x86.h                    |    3 ++-
>>>  7 files changed, 38 insertions(+), 10 deletions(-)

