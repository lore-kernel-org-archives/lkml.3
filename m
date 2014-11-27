Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbaK0TED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:04:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaK0TEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:04:01 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/4] KVM: x86: APIC fixes
Date: Thu, 27 Nov 2014 20:03:10 +0100
Message-Id: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interesting one is [3/4], which improves upon a previous CVE fix;
we also handle logical destination wrapping in it, so [2/4] does the
same for physical;  and to make it nicer, [1/4] removes a condition.
[4/4] makes our fast path return true when the message was handled.

Radim Krčmář (4):
  KVM: x86: deliver phys lowest-prio
  KVM: x86: fix APIC physical destination wrapping
  KVM: x86: allow 256 logical x2APICs again
  KVM: x86: don't retry hopeless APIC delivery

 arch/x86/kvm/lapic.c | 20 +++++++++++---------
 arch/x86/kvm/lapic.h |  2 --
 2 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.1.0

