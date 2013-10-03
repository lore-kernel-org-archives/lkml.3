Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3JCEJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:09:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab3JCEJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:09:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masoud Sharbiani <msharbiani@twitter.com>,
        Vinson Lee <vlee@twitter.com>, Robin Holt <holt@sgi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ingo Molnar <mingo@kernel.org>
Subject: [ 01/16] x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically
Date: Wed,  2 Oct 2013 21:05:25 -0700
Message-Id: <20131003040445.623679070@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040445.523176877@linuxfoundation.org>
References: <20131003040445.523176877@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masoud Sharbiani <msharbiani@twitter.com>

commit 4f0acd31c31f03ba42494c8baf6c0465150e2621 upstream.

Dell PowerEdge C6100 machines fail to completely reboot about 20% of the time.

Signed-off-by: Masoud Sharbiani <msharbiani@twitter.com>
Signed-off-by: Vinson Lee <vlee@twitter.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Link: http://lkml.kernel.org/r/1379717947-18042-1-git-send-email-vlee@freedesktop.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/reboot.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -479,6 +479,22 @@ static struct dmi_system_id __initdata p
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
+	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
 	{ }
 };
 


