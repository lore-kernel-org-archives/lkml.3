Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbaEFAlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbaEFAlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:41:11 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] Emulator Speedups - Optimize Instruction fetches
Date: Mon,  5 May 2014 20:40:56 -0400
Message-Id: <1399336859-7227-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My initial attempt at caching gva->gpa->hva translations. Pretty straight
forward with details in the individual patches.

I haven't yet looked into if there are other possibilities
to speed things up, just thought of sending these out since 
the numbers are better

567 cycles/emulated jump instruction
718 cycles/emulated move instruction
730 cycles/emulated arithmetic instruction
946 cycles/emulated memory load instruction
956 cycles/emulated memory store instruction
921 cycles/emulated memory RMW instruction

Old realmode.flat numbers from init ctxt changes -
https://lkml.org/lkml/2014/4/16/848

639 cycles/emulated jump instruction (4.3%)
776 cycles/emulated move instruction (7.5%)
791 cycles/emulated arithmetic instruction (11%)
943 cycles/emulated memory load instruction (5.2%)
948 cycles/emulated memory store instruction (7.6%)
929 cycles/emulated memory RMW instruction (9.0%)

Bandan Das (3):
  KVM: x86: pass ctxt to fetch helper function
  KVM: x86: use memory_prepare in fetch helper function
  KVM: x86: cache userspace address for faster fetches

 arch/x86/include/asm/kvm_emulate.h |  7 +++++-
 arch/x86/kvm/x86.c                 | 46 ++++++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 13 deletions(-)

-- 
1.8.3.1

