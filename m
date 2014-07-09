Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaGILgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:36:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53572 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbaGILga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:30 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-78-53bd293b232c
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 05/21] x86: cpu: don't sanitize early stages
 of a secondary CPU boot
Date: Wed, 09 Jul 2014 15:29:59 +0400
Message-id: <1404905415-9046-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7rWmnuDDS6vUrDY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroydJ38xFexjrdizfipLA+Nl
	li5GTg4JAROJvbub2CBsMYkL99YD2VwcQgJLGSUuLj7HDpIQEuhjklhzzQvEZhPQk/g3aztY
	g4iAgsTm3mesIA3MAs1sEu0dH1hBEsIC6RJT5x1mBrFZBFQlpk+bAGbzCrhK9EybCLVNQWLZ
	8plg9ZwCbhITpl8DquEAWuYqMWGF2gRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcx
	QiLp6w7GpcesDjEKcDAq8fC+2L0nWIg1say4MvcQowQHs5IIr63o3mAh3pTEyqrUovz4otKc
	1OJDjEwcnFINjKX5jJJxSrNm+rqVul37t1o7oUzSYTVf1ofHs+JDxHPcVnUtsvvduGpW1C6J
	wK6de5YXTxN65BNluUjv7s6507bPnJnlcqXn4YYPZw1YO7asdN77XOGDIEvMrY6JbVOfcDbq
	TJA8Y7t5/oUbGz/+cp6WHXl+6tK8mUWGTM7eSY/qFdULO5f+0FViKc5INNRiLipOBACZdNI4
	ggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumentation of this files may result in unbootable machine.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/kernel/cpu/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 7fd54f0..a7bb360 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -8,6 +8,9 @@ CFLAGS_REMOVE_common.o = -pg
 CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
+KASAN_SANITIZE_common.o := n
+KASAN_SANITIZE_perf_event.o := n
+
 # Make sure load_percpu_segment has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
-- 
1.8.5.5

