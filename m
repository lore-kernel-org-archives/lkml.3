Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaAIRFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:05:39 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:48337 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaAIRF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:05:28 -0500
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 12:05:26 -0500
Message-ID: <CAHqbYQt4o+sr8s4RVLdsMPMjx-SzTR8ccCuxwYXOoain91=3dQ@mail.gmail.com>
Subject: Emulated Guest TLB flush IPIs in qemu-kvm
From: Hu Yaohui <loki2441@gmail.com>
To: kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.
If the hardware does not support APIC virtualization: kvm_vcpu_kick sends an
host-IPI to the remote vcpu if that vcpu is in guest mode, a VM-exit
(exit reason: external interrupt) will be triggered due to the host-IPI.
Then on VM-entry (inject_pending_event) the guest-IPI is injected. If
that IPI is a TLB flush IPI,
what will happen if the target vcpu access the stale tlb entry before
the host-IPI arrives?
Thanks for your time!

Best Wishes,
Yaohui Hu
