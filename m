Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaAQNhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:37:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:16941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaAQNhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:37:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="440393746"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Why is (2 < 2) true? Is it a gcc bug?
Thread-Topic: Why is (2 < 2) true? Is it a gcc bug?
Thread-Index: Ac8TiNMTmnptR9ryRvWTI5/er276UQ==
Date: Fri, 17 Jan 2014 13:37:17 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

My story is very simply...
I applied the following patch:

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -698,8 +698,11 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_host_alloc;
 
-	for_each_isci_host(i, isci_host, pdev)
+	for_each_isci_host(i, isci_host, pdev) {
+		pr_err("(%d < %d) == %d\n",\
+		       i, SCI_MAX_CONTROLLERS, (i < SCI_MAX_CONTROLLERS));
 		scsi_scan_host(to_shost(isci_host));
+	}
 
 	return 0;
 
-- 
1.8.3.1

Then I issued the command 'modprobe isci' on platform with two SCU controllers (Patsburg D or T chipset)
and received the following, very strange, output:

(0 < 2) == 1
(1 < 2) == 1
(2 < 2) == 1

Can anyone explain why (2 < 2) is true? Is it a gcc bug?

(The kernel was compiled using gcc version 4.8.2.)

Lukasz

