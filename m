Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbbA2CnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:43:02 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34347 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbbA2Cm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:42:59 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 23:49:15 +0800
Message-ID: <CACzj_yWYwnt5duHJjPSDUY=iP-6Xke7jTkJVPVdpaBGzJWFh+Q@mail.gmail.com>
Subject: [PATCH v4 0/6] KVM: nVMX: Enable nested apicv support
To: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        =?UTF-8?B?6IyD5paH5LiA?= <fanwenyi0529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 ---> v2:
  Use spin lock to ensure vmcs12 is safe when doing nested
  posted interrupt delivery.

v2 ---> v3:
  1. Add a new field in nested_vmx to avoid the spin lock in v2.
  2. Drop send eoi to L1 when doing nested interrupt delivery.
  3. Use hardware MSR bitmap to enable nested virtualize x2apic
     mode.

v3 ---> v4:
  1. Optimize nested msr bitmap merging.
  2. Allocate nested msr bitmap only when nested == 1.
  3. Inline the nested vmx control checking functions.

Wincy Van (6):
  KVM: nVMX: Use hardware MSR bitmap
  KVM: nVMX: Enable nested virtualize x2apic mode
  KVM: nVMX: Make nested control MSRs per-cpu
  KVM: nVMX: Enable nested apic register virtualization
  KVM: nVMX: Enable nested virtual interrupt delivery
  KVM: nVMX: Enable nested posted interrupt processing

 arch/x86/kvm/vmx.c |  580 +++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 480 insertions(+), 100 deletions(-)
