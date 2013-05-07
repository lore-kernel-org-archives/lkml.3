Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3EGEEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:04:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760308Ab3EGD6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:53 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HVDtVFfsjhUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5d6fjfFho6wA:10 a=pGLkceISAAAA:8 a=iox4zFpeAAAA:8 a=hhmn9ELmAAAA:8 a=rOa8c4RQ97JTiWRzsc4A:9 a=MSl-tDqOz04A:10 a=n9GBPR9yFnkA:10 a=gpwweziqXSoA:10 a=jeBq3FmKZ4MA:10 a=ASHooyhLbZtVDIXh:21 a=5x38CaDTtLZQpfq9:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035846.364775444@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>, Anisse Astier <anisse@astier.eu>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [033/126] msi-wmi: Fix memory leak
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0033-msi-wmi-Fix-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit 51c94491c82c3d9029f6e87a1a153db321d88e35 ]

Fix memory leak - don't forget to kfree ACPI object when returning from
msi_wmi_notify() after suppressing key event.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Acked-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/platform/x86/msi-wmi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index 2264331..b96766b 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -176,7 +176,7 @@ static void msi_wmi_notify(u32 value, void *context)
 				pr_debug("Suppressed key event 0x%X - "
 					 "Last press was %lld us ago\n",
 					 key->code, ktime_to_us(diff));
-				return;
+				goto msi_wmi_notify_exit;
 			}
 			last_pressed[key->code - SCANCODE_BASE] = cur;
 
@@ -195,6 +195,8 @@ static void msi_wmi_notify(u32 value, void *context)
 			pr_info("Unknown key pressed - %x\n", eventcode);
 	} else
 		pr_info("Unknown event received\n");
+
+msi_wmi_notify_exit:
 	kfree(response.pointer);
 }
 
-- 
1.7.10.4


