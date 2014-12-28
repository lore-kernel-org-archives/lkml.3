Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaL1JKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:10:10 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37874 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaL1JKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 04:10:07 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.19-rc2 (or -rc3)
Date: Sun, 28 Dec 2014 10:10:00 +0100
Message-Id: <1419757800-12065-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to dbaff30940d6ef9bfa5f1f0c819cf3344ed3129f:

  kvm: warn on more invariant breakage (2014-12-28 10:01:25 +0100)

----------------------------------------------------------------
The important fixes are for two bugs introduced by the merge window.

On top of this, add a couple of WARN_ONs and stop spamming dmesg on
pretty much every boot of a virtual machine.

----------------------------------------------------------------
Paolo Bonzini (3):
      kvm: x86: drop severity of "generation wraparound" message
      kvm: fix sorting of memslots with base_gfn == 0
      kvm: warn on more invariant breakage

Tiejun Chen (1):
      kvm: x86: vmx: reorder some msr writing

 arch/x86/kvm/mmu.c  |  2 +-
 arch/x86/kvm/vmx.c  | 88 ++++++++++++++++++++++++++---------------------------
 virt/kvm/kvm_main.c | 26 ++++++++++++----
 3 files changed, 65 insertions(+), 51 deletions(-)
