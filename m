Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3E0E6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 00:58:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:7996 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3E0E6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 00:58:00 -0400
X-Spam-Score: -100.8
Message-ID: <51A2E7A5.5000904@asianux.com>
Date: Mon, 27 May 2013 12:57:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
CC: Parisc List <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: parisc: kernel: memory overflow, 'name' length is too
 short for using
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'path.bc[i]' can be asigned by PCI_SLOT() which can '> 10', so sizeof(6
* "%u:" + "%u" + '\0') may be 21.

Since 'name' length is 20, it may be memory overflow.

And 'path.bc[i]' is 'unsigned char' for printing, we can be sure the
max length of 'name' must be less than 28.

So simplify thinking, we can use 28 instead of 20 directly, and do not
think of whether 'patchc.bc[i]' can '> 100'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/parisc/kernel/drivers.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 5709c5e..14285ca 100644
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
 
-- 
1.7.7.6
