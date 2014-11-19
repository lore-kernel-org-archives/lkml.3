Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbaKSWMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:12:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbaKSVEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.17 135/141] quirk for Lenovo Yoga 3: no rfkill switch
Date: Wed, 19 Nov 2014 12:52:38 -0800
Message-Id: <20141119205155.412604551@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Mueller <smueller@chronox.de>

commit 725c7f619e20f5051bba627fca11dc107c2a93b1 upstream.

The Yoga 3 does not contain any physical rfkill switch. Therefore
disable the rfkill switch identically to the Yoga 2 approach.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/ideapad-laptop.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -837,6 +837,13 @@ static const struct dmi_system_id no_hw_
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Yoga 2"),
 		},
 	},
+	{
+		.ident = "Lenovo Yoga 3 Pro 1370",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo YOGA 3 Pro-1370"),
+		},
+	},
 	{}
 };
 


