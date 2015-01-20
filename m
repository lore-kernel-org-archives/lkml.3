Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbbATNju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:39:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbbATNjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:39:48 -0500
Date: Tue, 20 Jan 2015 05:39:33 -0800
From: "tip-bot for K. Y. Srinivasan" <tipbot@zytor.com>
Message-ID: <tip-32c6590d126836a062b3140ed52d898507987017@git.kernel.org>
Cc: kys@microsoft.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, mingo@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, kys@microsoft.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1421108762-3331-1-git-send-email-kys@microsoft.com>
References: <1421108762-3331-1-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hyperv:
  Mark the Hyper-V clocksource as being continuous
Git-Commit-ID: 32c6590d126836a062b3140ed52d898507987017
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32c6590d126836a062b3140ed52d898507987017
Gitweb:     http://git.kernel.org/tip/32c6590d126836a062b3140ed52d898507987017
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Mon, 12 Jan 2015 16:26:02 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 14:36:25 +0100

x86, hyperv: Mark the Hyper-V clocksource as being continuous

The Hyper-V clocksource is continuous; mark it accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Acked-by: jasowang@redhat.com
Cc: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org
Cc: olaf@aepfle.de
Cc: apw@canonical.com
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1421108762-3331-1-git-send-email-kys@microsoft.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mshyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index a450373..939155f 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -107,6 +107,7 @@ static struct clocksource hyperv_cs = {
 	.rating		= 400, /* use this when running on Hyperv*/
 	.read		= read_hv_clock,
 	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init ms_hyperv_init_platform(void)
