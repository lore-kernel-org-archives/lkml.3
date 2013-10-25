Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3JYLsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:48:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3JYLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:48:42 -0400
Date: Fri, 25 Oct 2013 04:48:23 -0700
From: tip-bot for Lan Tianyu <tipbot@zytor.com>
Message-ID: <tip-6d9153bbce50d41802ad2e20ce52daf699a3e8ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, tianyu.lan@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tianyu.lan@intel.com
In-Reply-To: <1382598693-29334-1-git-send-email-tianyu.lan@intel.com>
References: <1382598693-29334-1-git-send-email-tianyu.lan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86/reboot: Correct pr_info()
  log message in the set_bios/pci/kbd_reboot()
Git-Commit-ID: 6d9153bbce50d41802ad2e20ce52daf699a3e8ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 04:48:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d9153bbce50d41802ad2e20ce52daf699a3e8ad
Gitweb:     http://git.kernel.org/tip/6d9153bbce50d41802ad2e20ce52daf699a3e8ad
Author:     Lan Tianyu <tianyu.lan@intel.com>
AuthorDate: Thu, 24 Oct 2013 15:11:33 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Oct 2013 12:45:04 +0200

x86/reboot: Correct pr_info() log message in the set_bios/pci/kbd_reboot()

commit:

  c767a54ba065 x86/debug: Add KERN_<LEVEL> to bare printks, convert printks to pr_<level>

broke the log messages in the set_bios/pci/kbd_reboot() functions, by
putting the reboot method string and quirk entry's ident string in the
wrong order. This patch fixes it.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Cc: holt@sgi.com
Cc: davej@fedoraproject.org
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: awilliam@redhat.com
Link: http://lkml.kernel.org/r/1382598693-29334-1-git-send-email-tianyu.lan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7692520..da1fe1c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -61,7 +61,7 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_BIOS) {
 		reboot_type = BOOT_BIOS;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
-			"BIOS", d->ident);
+			d->ident, "BIOS");
 	}
 	return 0;
 }
@@ -117,7 +117,7 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_CF9) {
 		reboot_type = BOOT_CF9;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
-			"PCI", d->ident);
+			d->ident, "PCI");
 	}
 	return 0;
 }
@@ -127,7 +127,7 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_KBD) {
 		reboot_type = BOOT_KBD;
 		pr_info("%s series board detected. Selecting %s-method for reboot.\n",
-			"KBD", d->ident);
+			d->ident, "KBD");
 	}
 	return 0;
 }
