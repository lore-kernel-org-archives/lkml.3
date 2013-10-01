Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3JANBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:01:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3JANBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:01:07 -0400
Date: Tue, 1 Oct 2013 06:00:48 -0700
From: tip-bot for Bartlomiej Zolnierkiewicz <tipbot@zytor.com>
Message-ID: <tip-a6d30e0fffb32ab9e48fa7fc8f463805d5b0bddb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        b.zolnierkie@samsung.com, tglx@linutronix.de,
        kyungmin.park@samsung.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com, tglx@linutronix.de,
        kyungmin.park@samsung.com
In-Reply-To: <18427893.G5JGWn465D@amdc1032>
References: <18427893.G5JGWn465D@amdc1032>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/geode:
  Fix incorrect placement of __initdata tag
Git-Commit-ID: a6d30e0fffb32ab9e48fa7fc8f463805d5b0bddb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 01 Oct 2013 06:00:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6d30e0fffb32ab9e48fa7fc8f463805d5b0bddb
Gitweb:     http://git.kernel.org/tip/a6d30e0fffb32ab9e48fa7fc8f463805d5b0bddb
Author:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
AuthorDate: Mon, 30 Sep 2013 15:21:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 1 Oct 2013 13:21:27 +0200

x86/geode: Fix incorrect placement of __initdata tag

__initdata tag should be placed between the variable name and
equal sign for the variable to be placed in the intended
.init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Link: http://lkml.kernel.org/r/18427893.G5JGWn465D@amdc1032
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/geode/alix.c    | 2 +-
 arch/x86/platform/geode/geos.c    | 2 +-
 arch/x86/platform/geode/net5501.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.c
index 90e23e7..76b6632 100644
--- a/arch/x86/platform/geode/alix.c
+++ b/arch/x86/platform/geode/alix.c
@@ -98,7 +98,7 @@ static struct platform_device alix_leds_dev = {
 	.dev.platform_data = &alix_leds_data,
 };
 
-static struct __initdata platform_device *alix_devs[] = {
+static struct platform_device *alix_devs[] __initdata = {
 	&alix_buttons_dev,
 	&alix_leds_dev,
 };
diff --git a/arch/x86/platform/geode/geos.c b/arch/x86/platform/geode/geos.c
index c2e6d53..aa733fb 100644
--- a/arch/x86/platform/geode/geos.c
+++ b/arch/x86/platform/geode/geos.c
@@ -87,7 +87,7 @@ static struct platform_device geos_leds_dev = {
 	.dev.platform_data = &geos_leds_data,
 };
 
-static struct __initdata platform_device *geos_devs[] = {
+static struct platform_device *geos_devs[] __initdata = {
 	&geos_buttons_dev,
 	&geos_leds_dev,
 };
diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
index 646e3b5..927e38c 100644
--- a/arch/x86/platform/geode/net5501.c
+++ b/arch/x86/platform/geode/net5501.c
@@ -78,7 +78,7 @@ static struct platform_device net5501_leds_dev = {
 	.dev.platform_data = &net5501_leds_data,
 };
 
-static struct __initdata platform_device *net5501_devs[] = {
+static struct platform_device *net5501_devs[] __initdata = {
 	&net5501_buttons_dev,
 	&net5501_leds_dev,
 };
