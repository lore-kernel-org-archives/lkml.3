Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaBURwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:52:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:50534 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbaBURwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,520,1389772800"; 
   d="scan'208";a="459568643"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: [PATCH v4 0/3] KVM: x86: enable Intel MPX for KVM
Thread-Topic: [PATCH v4 0/3] KVM: x86: enable Intel MPX for KVM
Thread-Index: Ac8vLaMbgSGqpZuuRqWCQDSogscsfQ==
Date: Fri, 21 Feb 2014 17:52:07 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233501509BBE@SHSMSX101.ccr.corp.intel.com>
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

These patches are version 4 to enable Intel MPX for KVM.

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

Thanks,
Jinsong