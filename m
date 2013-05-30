Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289Ab3E3QAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:00:44 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41069 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934049Ab3E3QAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:00:38 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH 0/2] KVM: x86: minimal debugging support during emulation
Date: Thu, 30 May 2013 18:00:29 +0200
Message-Id: <1369929631-2101-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch to emulate_invalid_guest_state brought one slightly unwelcome
change; the debugging interface does not work in the initial boot phase
because KVM_SET_GUEST_DEBUG is basically ignored.

These two patches bring some initial support for debugging, namely for
hardware breakpoints and single-stepping.  Software breakpoints and
hardware watchpoints are still ignored.

Paolo

Paolo Bonzini (2):
  KVM: x86: handle hardware breakpoints during emulation
  KVM: x86: handle singlestep during emulation

 arch/x86/include/asm/kvm_emulate.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   3 +-
 arch/x86/kvm/emulate.c             |   1 +
 arch/x86/kvm/x86.c                 | 106 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 109 insertions(+), 2 deletions(-)

-- 
1.8.1.4

