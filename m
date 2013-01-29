Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3A2UAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:00:16 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:19434
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab3A2UAN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:00:13 -0500
X-Forefront-Antispam-Report: CIP:157.56.232.213;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0511HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: PS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah1954cbh8275bhz32i2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h1155h)
From: Scan Subscription <scan-subscription@coverity.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: New Defect(s) reported by Coverity Scan 
Thread-Topic: New Defect(s) reported by Coverity Scan 
Thread-Index: Ac3+WzufWxR2qwPvRxmctmgj0SjdvQ==
Date: Tue, 29 Jan 2013 20:00:05 +0000
Message-ID: <C0A4ACBB26D853488EA0C68388B7026816911123@BLUPRD0511MB401.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.125.71.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find the latest report on new defect(s) that have been introduced to the Linux Kernel found with Coverity SCAN. 


Defect(s) Reported-by: Coverity Scan:
___________________________________________________________________________
** CID 967920: Allocation too small for type (SIZECHECK)
/drivers/net/wireless/ath/wil6210/pcie_bus.c: 146
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=967920



###########################################################################
Defect Details:
___________________________________________________________________________
CID 967920: Allocation too small for type (SIZECHECK)
http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=967920

/drivers/net/wireless/ath/wil6210/pcie_bus.c: 146 ( buffer_alloc)
   143    	/* rollback to err_iounmap */
   144    	dev_info(&pdev->dev, "CSR at %pR -> %p\n", &pdev->resource[0], csr);
   145    
>>> "wil_if_alloc(dev, csr)" allocates memory.
   146    	wil = wil_if_alloc(dev, csr);
   147    	if (IS_ERR(wil)) {
   148    		rc = (int)PTR_ERR(wil);
   149    		dev_err(dev, "wil_if_alloc failed: %d\n", rc);
   150    		goto err_iounmap;
  

/drivers/net/wireless/ath/wil6210/pcie_bus.c: 146 ( size_error)
   143    	/* rollback to err_iounmap */
   144    	dev_info(&pdev->dev, "CSR at %pR -> %p\n", &pdev->resource[0], csr);
   145    
>>> CID 967920: Allocation too small for type (SIZECHECK) Allocating 920 
>>> bytes to pointer of type struct wil6210_priv, which needs at least 2304 bytes.
   146    	wil = wil_if_alloc(dev, csr);
   147    	if (IS_ERR(wil)) {
   148    		rc = (int)PTR_ERR(wil);
   149    		dev_err(dev, "wil_if_alloc failed: %d\n", rc);
   150    		goto err_iounmap;
  
________________________________________________________________________


To view the defects in Coverity Scan visit, http://scan5.coverity.com:8080.  
Your username should be the first part of your email address. If you don't have a username, you can request one by emailing: scan-admin at coverity.com
	
Thank you,
Dakshesh Vyas
Coverity SCAN-ADMIN
scan-admin at coverity.com
http://scan.coverity.com

