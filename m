Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaBXKxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:53:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:47301 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbaBXKxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:53:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,534,1389772800"; 
   d="scan'208";a="460981301"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "'Paolo Bonzini'" <pbonzini@redhat.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
CC: "'gleb@redhat.com'" <gleb@redhat.com>, "'hpa@zytor.com'" <hpa@zytor.com>
Subject: [PATCH v5 0/3] KVM: x86: enable Intel MPX for KVM
Thread-Topic: [PATCH v5 0/3] KVM: x86: enable Intel MPX for KVM
Thread-Index: Ac8xTq9acMp5vNsrSneGN2AQMGL6yQ==
Date: Mon, 24 Feb 2014 10:53:43 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350150E3B8@SHSMSX101.ccr.corp.intel.com>
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

These patches are version 5 to enable Intel MPX for KVM.

Version 1:
  * Add some Intel MPX definiation
  * Fix a cpuid(0x0d, 0) exposing bug, dynamic per XCR0 features enable/disable 
  * vmx and msr handle for MPX support at KVM
  * enalbe MPX feature for guest

Version 2:
  * remove generic MPX definiation, Qiaowei's patch has add the definiation at kernel side
  * add MSR_IA32_BNDCFGS to msrs_to_save

Version 3:
  * rebase on latest kernel, which include Qiaowei's MPX common definiation pulled from HPA's tree

Version 4:
  * Remove xsave bugfix patch from this series as a standalone patch
  * Add a new kvm_x86_ops member mpx_supported, to disable MPX whenever the two VMX controls are not available
  * minor rebase for VMX bit definition

Version 5:
  * Add conditional mpx_supported when expose MPX to guest

Thanks,
Jinsong


Liu Jinsong (3):
  KVM: x86: Intel MPX vmx and msr handle
  KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save
  KVM: x86: Enable Intel MPX for guest

 arch/x86/include/asm/kvm_host.h       |    1 +
 arch/x86/include/asm/vmx.h            |    4 ++++
 arch/x86/include/uapi/asm/msr-index.h |    1 +
 arch/x86/kvm/cpuid.c                  |    4 +++-
 arch/x86/kvm/vmx.c                    |   24 ++++++++++++++++++++++--
 arch/x86/kvm/x86.c                    |    8 +++++++-
 arch/x86/kvm/x86.h                    |    3 ++-
 7 files changed, 40 insertions(+), 5 deletions(-)
