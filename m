Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3FYTO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:14:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FYSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 02/95] ARM: 7754/1: Fix the CPU ID and the mask associated to the PJ4B
Date: Tue, 25 Jun 2013 11:31:49 -0700
Message-Id: <20130625182153.915257183@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit 049be07053ebbf0ee8543caea23ae7bdf0765bb2 upstream.

This commit fixes the ID and mask for the PJ4B which was too
restrictive and didn't match the CPU of the Armada 370 SoC.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/proc-v7.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -407,8 +407,8 @@ __v7_ca9mp_proc_info:
 	 */
 	.type   __v7_pj4b_proc_info, #object
 __v7_pj4b_proc_info:
-	.long	0x562f5840
-	.long	0xfffffff0
+	.long	0x560f5800
+	.long	0xff0fff00
 	__v7_proc __v7_pj4b_setup
 	.size	__v7_pj4b_proc_info, . - __v7_pj4b_proc_info
 #endif	/* CONFIG_ARM_LPAE */


