Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaLBLPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:15:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:10624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbaLBLP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:15:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,500,1413270000"; 
   d="scan'208";a="641284961"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3 0/3] kvm: vmx: enable xsaves for kvm
Date: Tue,  2 Dec 2014 19:14:57 +0800
Message-Id: <1417518900-42446-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to enable xsaves for kvm part, the patch for 
qemu part will be sent out later. 

The patchset is tested on skylake-client.

v2 -> v3:
 * add kvm_get/set for ia32_xss
 * fix the type XSS_EXIT_BITMAP
 * load host_xss just once in setup_vmcs_config
 * add/clear atuo switch ia32_xss msr in kvm_get/clear
 * add VMX_XSS_EXIT_BITMAP macro
 * add WARN() in handle_xsaves/xrstors
 * export xsaves if related vmcs field is set 

v1 -> v2: 
 * auto switch ia32_xss msr just if this msr is present 

Wanpeng Li (3):
  kvm: x86: Intel XSAVES vmx and msr handle
  kvm: vmx: add kvm_get/set logic to xsaves
  kvm: x86: Enable Intel XSAVES for guest

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/asm/vmx.h      |  3 +++
 arch/x86/include/uapi/asm/vmx.h |  6 ++++-
 arch/x86/kvm/cpuid.c            |  3 ++-
 arch/x86/kvm/vmx.c              | 51 ++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 62 insertions(+), 3 deletions(-)

-- 
1.9.1

