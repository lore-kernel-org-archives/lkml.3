Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3FWLCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:02:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FWLCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:02:22 -0400
Date: Sun, 23 Jun 2013 04:02:05 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-fc58be7596b832ee9635b2f7090a589ac5cdb807@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1371801891-23618-1-git-send-email-bp@alien8.de>
References: <1371801891-23618-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform:
  Add kvmconfig to the phony targets
Git-Commit-ID: fc58be7596b832ee9635b2f7090a589ac5cdb807
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 23 Jun 2013 04:02:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc58be7596b832ee9635b2f7090a589ac5cdb807
Gitweb:     http://git.kernel.org/tip/fc58be7596b832ee9635b2f7090a589ac5cdb807
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 21 Jun 2013 10:04:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 23 Jun 2013 12:17:35 +0200

x86/platform: Add kvmconfig to the phony targets

... so as not to disable it with a file of the same name in the
toplevel build directory.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1371801891-23618-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 91ee171..07639c6 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -220,6 +220,7 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
+PHONY += kvmconfig
 kvmconfig:
 	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config arch/x86/configs/kvm_guest.config
