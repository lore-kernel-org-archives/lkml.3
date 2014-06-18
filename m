Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbaFRKQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:16:08 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52156 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965123AbaFRKQF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:16:05 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pratyush ANAND <pratyush.anand@st.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Date: Wed, 18 Jun 2014 18:14:28 +0800
Subject: RE: [PATCH v2 0/8] Add Keystone PCIe controller driver
Thread-Topic: [PATCH v2 0/8] Add Keystone PCIe controller driver
Thread-Index: Ac+E3Sskd0J36VlqT7KlUC+syPQvVgF/e5fQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB6619C5F8169D1@EAPEX1MAIL1.st.com>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-18_04:2014-06-17,2014-06-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Murali,

> -----Original Message-----
> From: Murali Karicheri [mailto:m-karicheri2@ti.com]
> Sent: Wednesday, June 11, 2014 12:21 AM
> To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> linux-pci@vger.kernel.org; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org
> Cc: Murali Karicheri; Santosh Shilimkar; Russell King; Grant Likely; Rob Herring;
> Mohit KUMAR DCG; Jingoo Han; Bjorn Helgaas; Pratyush ANAND; Richard
> Zhu; Kishon Vijay Abraham I; Marek Vasut; Arnd Bergmann; Pawel Moll;
> Mark Rutland; Ian Campbell; Kumar Gala; Randy Dunlap
> Subject: [PATCH v2 0/8] Add Keystone PCIe controller driver
> 
> This patch adds a PCIe controller driver for Keystone SoCs. This is based on v1
> of the series posted to the mailing list.
> 

1. I think your first patch is OK which handles platform specific ATU implementation.

2. For MSI part, I think you just need to add two new callbacks with pp-ops, something similar to:
pp->ops->msi_set
pp->ops->msi_clear

With these two platform specific callbacks you should be able to manage MSI handling.
So idea is that dw_msi code uses pp->ops->msi_set/clear if platform define these,
otherwise use dw_msi_set/clear (which you need to refactor from existing code)

So other than your keystone changes we expect 3 patches:
--  1st same as you sent 1/8: for ATU handeling
-- 2nd to refactor dw_msi_set/clear: refactor from existing code
-- 3rd to use pp->ops->msi_set/clear if defined.

Pls let us know for any issue or have different opinion.

Regards
Mohit



 
> 
> --
> 1.7.9.5

