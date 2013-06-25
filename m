Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3FYSdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:33:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3FYSdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, Helge Deller <deller@gmx.de>
Subject: [ 21/95] parisc: memory overflow, name length is too short for using
Date: Tue, 25 Jun 2013 11:32:08 -0700
Message-Id: <20130625182156.034280348@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 3f108de96ba449a8df3d7e3c053bf890fee2cb95 upstream.

'path.bc[i]' can be asigned by PCI_SLOT() which can '> 10', so sizeof(6
* "%u:" + "%u" + '\0') may be 21.

Since 'name' length is 20, it may be memory overflow.

And 'path.bc[i]' is 'unsigned char' for printing, we can be sure the
max length of 'name' must be less than 28.

So simplify thinking, we can use 28 instead of 20 directly, and do not
think of whether 'patchc.bc[i]' can '> 100'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/drivers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -394,7 +394,7 @@ EXPORT_SYMBOL(print_pci_hwpath);
 static void setup_bus_id(struct parisc_device *padev)
 {
 	struct hardware_path path;
-	char name[20];
+	char name[28];
 	char *output = name;
 	int i;
 


