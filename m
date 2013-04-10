Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937380Ab3DJXHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:07:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937343Ab3DJWrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Anisse Astier <anisse@astier.eu>, "Lee, Chun-Yi" <jlee@suse.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 53/64] msi-wmi: Fix memory leak
Date: Wed, 10 Apr 2013 15:46:50 -0700
Message-Id: <20130410224345.793251684@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Mikityanskiy <maxtram95@gmail.com>

commit 51c94491c82c3d9029f6e87a1a153db321d88e35 upstream.

Fix memory leak - don't forget to kfree ACPI object when returning from
msi_wmi_notify() after suppressing key event.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Acked-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/platform/x86/msi-wmi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -176,7 +176,7 @@ static void msi_wmi_notify(u32 value, vo
 				pr_debug("Suppressed key event 0x%X - "
 					 "Last press was %lld us ago\n",
 					 key->code, ktime_to_us(diff));
-				return;
+				goto msi_wmi_notify_exit;
 			}
 			last_pressed[key->code - SCANCODE_BASE] = cur;
 
@@ -195,6 +195,8 @@ static void msi_wmi_notify(u32 value, vo
 			pr_info("Unknown key pressed - %x\n", eventcode);
 	} else
 		pr_info("Unknown event received\n");
+
+msi_wmi_notify_exit:
 	kfree(response.pointer);
 }
 


