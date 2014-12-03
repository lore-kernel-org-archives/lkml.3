Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaLCBCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:02:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:64640 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaLCBCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:02:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="492634546"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v4 0/3] kvm: vmx: enable xsaves for kvm
Date: Wed,  3 Dec 2014 09:01:51 +0800
Message-Id: <1417568514-7180-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to enable xsaves for kvm part and tested on skylake-client.

v3 -> v4:
 * return false from an svm_xsaves_supported function
 * prevent setting MSR_IA32_XSS to any non-zero value

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
  kvm: vmx: Intel XSAVES vmx and msr handle
  kvm: vmx: add kvm_get/set logic to xsaves
  kvm: x86: Enable Intel XSAVES for guest

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/asm/vmx.h      |  3 +++
 arch/x86/include/uapi/asm/vmx.h |  6 ++++-
 arch/x86/kvm/cpuid.c            |  3 ++-
 arch/x86/kvm/svm.c              |  6 +++++
 arch/x86/kvm/vmx.c              | 57 ++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 74 insertions(+), 3 deletions(-)

-- 
1.9.1

