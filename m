Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbbANHgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:36:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbbANHgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:36:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.14 65/77] arm64: kernel: add missing __init section marker to cpu_suspend_init
Date: Tue, 13 Jan 2015 23:23:45 -0800
Message-Id: <20150114072227.881090635@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>

commit 18ab7db6b749ac27aac08d572afbbd2f4d937934 upstream.

Suspend init function must be marked as __init, since it is not needed
after the kernel has booted. This patch moves the cpu_suspend_init()
function to the __init section.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/suspend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -119,7 +119,7 @@ int cpu_suspend(unsigned long arg)
 extern struct sleep_save_sp sleep_save_sp;
 extern phys_addr_t sleep_idmap_phys;
 
-static int cpu_suspend_init(void)
+static int __init cpu_suspend_init(void)
 {
 	void *ctx_ptr;
 


