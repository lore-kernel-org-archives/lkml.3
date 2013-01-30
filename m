Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3A3W6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:58:17 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:55147 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3A3W6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:58:15 -0500
MIME-Version: 1.0
From: Tristan Schmelcher <tschmelcher@google.com>
Date: Wed, 30 Jan 2013 14:57:53 -0800
Message-ID: <CADNZ+wS1yU886b_LosvHnknKZahbn=CSEZoPBUtqtc9odyz6RA@mail.gmail.com>
Subject: [PATCH] uml: Always use 3_LEVEL_PGTABLES on x86_64
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristan Schmelcher <tschmelcher@google.com>

Use 3_LEVEL_PGTABLES on x86_64 even if EXPERIMENTAL is off, since
otherwise UML does not work. Applies to 3.7.1.

Signed-off-by: Tristan Schmelcher <tschmelcher@google.com>
---

--- linux-3.7.1/arch/x86/um/Kconfig.orig        2013-01-23
15:50:12.671408478 -0800
+++ linux-3.7.1/arch/x86/um/Kconfig     2013-01-23 15:44:38.321878377 -0800
@@ -39,7 +39,7 @@ config RWSEM_GENERIC_SPINLOCK
 config 3_LEVEL_PGTABLES
        bool "Three-level pagetables (EXPERIMENTAL)" if !64BIT
        default 64BIT
-       depends on EXPERIMENTAL
+       depends on EXPERIMENTAL || 64BIT
        help
        Three-level pagetables will let UML have more than 4G of physical
        memory.  All the memory that can't be mapped directly will be treated
