Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3IXIix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:38:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3IXIi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:38:27 -0400
Date: Tue, 24 Sep 2013 01:38:16 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8a1f4653f27ffd5d61088cf6b95c39bb13bf6132@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        travis@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        travis@sgi.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV: Check for alloc_cpumask_var()
  failures properly in uv_nmi_setup()
Git-Commit-ID: 8a1f4653f27ffd5d61088cf6b95c39bb13bf6132
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 24 Sep 2013 01:38:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a1f4653f27ffd5d61088cf6b95c39bb13bf6132
Gitweb:     http://git.kernel.org/tip/8a1f4653f27ffd5d61088cf6b95c39bb13bf6132
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 24 Sep 2013 09:52:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 24 Sep 2013 09:52:40 +0200

x86/UV: Check for alloc_cpumask_var() failures properly in uv_nmi_setup()

GCC warned about:

   arch/x86/platform/uv/uv_nmi.c: In function ‘uv_nmi_setup’:
   arch/x86/platform/uv/uv_nmi.c:664:2: warning: the address of ‘uv_nmi_cpu_mask’ will always evaluate as ‘true’

The reason is this code:

        alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL);
        BUG_ON(!uv_nmi_cpu_mask);

which is not the way to check for alloc_cpumask_var() failures - its
return code should be checked instead.

Cc: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/n/tip-2pXRemsjupmvonbpmmnzleo1@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/uv_nmi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index c171ca5..9126dfb 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -660,8 +660,7 @@ void uv_nmi_setup(void)
 		}
 		uv_hub_nmi_per(cpu) = uv_hub_nmi_list[nid];
 	}
-	alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL);
-	BUG_ON(!uv_nmi_cpu_mask);
+	BUG_ON(!alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL));
 }
 
 
