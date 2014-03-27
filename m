Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaC0Lat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:30:49 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37555 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaC0Lap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:30:45 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [RFC PATCH 0/5] KVM: speed up invalid guest state emulation
Date: Thu, 27 Mar 2014 12:30:33 +0100
Message-Id: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series identifies some low-hanging fruit for speeding up emulation
of invalid guest state.  I am a bit worried about patch 2, while
everything else should be relatively safe.

On the kvm-unit-tests microbenchmarks I get a 1.8-2.5x speedup (from 
740-1100 cycles/instruction to 280-600).

This is not for 3.15, of course.  Even patch 5 is not too useful without
the others; saving 40 clock cycles is a 10% speedup after the previous
patches, but only 4% before.

Please review carefully!

Paolo

Paolo Bonzini (5):
  KVM: vmx: speed up emulation of invalid guest state
  KVM: x86: avoid useless set of KVM_REQ_EVENT after emulation
  KVM: x86: move around some checks
  KVM: x86: protect checks on ctxt->d by a common "if (unlikely())"
  KVM: x86: speed up emulated moves

 arch/x86/include/asm/kvm_emulate.h |   2 +-
 arch/x86/kvm/emulate.c             | 182 ++++++++++++++++++++-----------------
 arch/x86/kvm/vmx.c                 |   5 +-
 arch/x86/kvm/x86.c                 |  28 ++++--
 4 files changed, 120 insertions(+), 97 deletions(-)

-- 
1.8.3.1

