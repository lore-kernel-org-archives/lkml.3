Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbAXKTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:19:22 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:45985 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAXKTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:19:18 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Sat, 24 Jan 2015 18:18:56 +0800
Message-ID: <CACzj_yVKMMJMdNjCn=64sqgEtcG9Jn3j=JitsprWB=hNnf19Ng@mail.gmail.com>
Subject: [PATCH v3 0/6] KVM: nVMX: Enable nested apicv support.
To: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

Wincy Van (6):
  KVM: nVMX: Use hardware MSR bitmap
  KVM: nVMX: Enable nested virtualize x2apic mode.
  KVM: nVMX: Make nested control MSRs per-cpu.
  KVM: nVMX: Enable nested apic register virtualization.
  KVM: nVMX: Enable nested virtual interrupt delivery.
  KVM: nVMX: Enable nested posted interrupt processing.

 arch/x86/kvm/vmx.c |  570 +++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 470 insertions(+), 100 deletions(-)
