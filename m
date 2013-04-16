Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3DPNu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:50:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab3DPNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:50:58 -0400
Date: Tue, 16 Apr 2013 06:50:45 -0700
From: tip-bot for Wang YanQing <tipbot@zytor.com>
Message-ID: <tip-26bfc540f6f2dcbd93d0b9ed8f37830419ded7e8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, udknight@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, udknight@gmail.com
In-Reply-To: <20130416013734.GA14641@udknight>
References: <20130416013734.GA14641@udknight>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm/gart: Drop unnecessary check
Git-Commit-ID: 26bfc540f6f2dcbd93d0b9ed8f37830419ded7e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Apr 2013 06:50:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26bfc540f6f2dcbd93d0b9ed8f37830419ded7e8
Gitweb:     http://git.kernel.org/tip/26bfc540f6f2dcbd93d0b9ed8f37830419ded7e8
Author:     Wang YanQing <udknight@gmail.com>
AuthorDate: Tue, 16 Apr 2013 09:37:34 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Apr 2013 10:54:40 +0200

x86/mm/gart: Drop unnecessary check

The memblock_find_in_range() return value addr is guaranteed
to be within "addr + aper_size" and not beyond GART_MAX_ADDR.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20130416013734.GA14641@udknight
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/aperture_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index d5fd66f..fd972a3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -87,7 +87,7 @@ static u32 __init allocate_aperture(void)
 	 */
 	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
 				      aper_size, aper_size);
-	if (!addr || addr + aper_size > GART_MAX_ADDR) {
+	if (!addr) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
 				addr, aper_size>>10);
