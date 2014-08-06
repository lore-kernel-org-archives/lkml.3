Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbaHFTeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:34:50 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38283 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbaHFTes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:34:48 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Liu hua <sdu.liu@huawei.com>,
        Mark Salter <msalter@redhat.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/7] arm: support CONFIG_RODATA
Date: Wed,  6 Aug 2014 12:32:37 -0700
Message-Id: <1407353564-21478-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches to support CONFIG_RODATA on ARM, so that
the kernel text is RO, and non-text sections default to NX. To support
on-the-fly kernel text patching (via ftrace, kprobes, etc), fixmap
support has been finalized based on several versions of various patches
that are floating around on the mailing list. This series attempts to
include the least intrusive version, so that others can build on it for
future fixmap work.

The series has been heavily tested, and appears to be working correctly:

With CONFIG_ARM_PTDUMP, expected page table permissions are seen in
/sys/kernel/debug/kernel_page_tables.

Using CONFIG_LKDTM, the kernel now correctly detects bad accesses for
for the following lkdtm tests via /sys/kernel/debug/provoke-crash/DIRECT:
        EXEC_DATA
        WRITE_RO
        WRITE_KERN

ftrace works:
	CONFIG_FTRACE_STARTUP_TEST passes
	Enabling tracing works:
	        echo function > /sys/kernel/debug/tracing/current_tracer

kprobes works:
	CONFIG_ARM_KPROBES_TEST passes

kexec works:
	kexec will load and start a new kernel

Thanks to everyone who has been testing this series and working on its
various pieces!

-Kees

