Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaFDXXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbaFDXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Edward Lin <yidi.lin@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 203/228] ACPI: blacklist win8 OSI for Dell Inspiron 7737
Date: Wed,  4 Jun 2014 16:23:52 -0700
Message-Id: <20140604232354.564576590@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Lin <yidi.lin@canonical.com>

commit b753631b3576bf343151a82513c5d56fcda1e24f upstream.

With win8 capabiltiy, the machine will boot itself immediately after
shutdown command has executed.

Work around this issue by disabling win8 capcability.  This workaround
also makes wireless hotkey work.

Signed-off-by: Edward Lin <yidi.lin@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/blacklist.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -314,6 +314,14 @@ static struct dmi_system_id acpi_osi_dmi
 		     DMI_MATCH(DMI_PRODUCT_VERSION, "2349D15"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "Dell Inspiron 7737",
+	.matches = {
+		    DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		    DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7737"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.


