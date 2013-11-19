Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3KSUXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:23:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18893 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3KSUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:22:58 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: gleb@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kvm: mmu: delay mmu audit activation
Date: Tue, 19 Nov 2013 15:22:47 -0500
Message-Id: <1384892567-20134-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not be using jump labels before they were initialized. Push back
the callback to until after jump label initialization.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/kvm/mmu_audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index daff69e..1185fe7 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -296,4 +296,4 @@ static struct kernel_param_ops audit_param_ops = {
 	.get = param_get_bool,
 };
 
-module_param_cb(mmu_audit, &audit_param_ops, &mmu_audit, 0644);
+arch_param_cb(mmu_audit, &audit_param_ops, &mmu_audit, 0644);
-- 
1.7.10.4

