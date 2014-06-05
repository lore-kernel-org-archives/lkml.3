Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaFEX5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 19:57:08 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:49228 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaFEX5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 19:57:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8CAPECkVOERCABjGdsb2JhbABZx0cBgQgWDgEBASc8giYBBXkQQBFXiFvNYYUxF45SBxaEKgSKJaZi
X-IPAS-Result: Ag8CAPECkVOERCABjGdsb2JhbABZx0cBgQgWDgEBASc8giYBBXkQQBFXiFvNYYUxF45SBxaEKgSKJaZi
X-IronPort-AV: E=Sophos;i="4.98,984,1392156000"; 
   d="scan'208";a="110197071"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 0/2] x86: Additional smsw tests
Date: Fri,  6 Jun 2014 02:56:51 +0300
Message-Id: <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <53908C66.20600@redhat.com>
References: <53908C66.20600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds two tests for smsw. The first one is intended to add
coverage of smsw. It covers the case smsw is executed with memory operand in a
page which is write-protected by the hypervisor. Note that the existing smsw
tests are not supposed to be trapped by the hypervisor. This test was added
just for additional coverage.

The realmode smsw test covers the recent patch that saves the high 16-bits to
32-bit register operand. Implementing a long-mode test is difficult since we
need to cause an "invalid guest state" in long-mode.

Nadav Amit (2):
  x86: emulator: additional smsw test-case
  x86: realmode: test smsw behavior with register operand

 x86/emulator.c | 10 ++++++++--
 x86/realmode.c | 15 +++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

-- 
1.9.1

