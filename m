Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbbABQVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:21:24 -0500
Received: from omr2.cc.vt.edu ([198.82.141.100]:37786 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbABQVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:21:23 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, robtongue@gmail.com
Subject: [PATCH] USB_EHCI_TT_NEWSCHED in *86 defconfig
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 02 Jan 2015 11:19:57 -0500
Message-ID: <212826.1420215597@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Gentoo users are encountering problems because USB_EHCI_TT_NEWSCHED isn't
set in the defconfig (and Gentoo differs from other distros in not providing a
distro .config).  Alan Stern has said there's no reason to not set it, and the
ability to turn it off at all should probably be yanked.

http://article.gmane.org/gmane.linux.usb.general/119920

This addresses issue https://bugs.gentoo.org/show_bug.cgi?id=533472

(The problem also theoretically affects the sh, arm, mips, powerpc, and
sparc archs, but those would be other patches if this one that fixes 98% of
the problem is accepted).

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- a/arch/x86/configs/i386_defconfig.dist	2014-12-19 12:38:51.467027402 -0500
+++ b/arch/x86/configs/i386_defconfig	2015-01-02 11:03:55.817776347 -0500
@@ -248,7 +248,7 @@ CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
-# CONFIG_USB_EHCI_TT_NEWSCHED is not set
+CONFIG_USB_EHCI_TT_NEWSCHED=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_UHCI_HCD=y
 CONFIG_USB_PRINTER=y
--- a/arch/x86/configs/x86_64_defconfig.dist	2014-12-19 12:38:51.467027402 -0500
+++ b/arch/x86/configs/x86_64_defconfig	2015-01-02 11:04:10.233816380 -0500
@@ -243,7 +243,7 @@ CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
-# CONFIG_USB_EHCI_TT_NEWSCHED is not set
+CONFIG_USB_EHCI_TT_NEWSCHED=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_UHCI_HCD=y
 CONFIG_USB_PRINTER=y

