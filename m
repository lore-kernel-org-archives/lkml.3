Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3FYRzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:55:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:1466 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3FYRz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="360315058"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "bp@alien8.de" <bp@alien8.de>
CC: "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: RE: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Thread-Topic: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Thread-Index: AQHOccwSjjVlORDVjkS9g/z7o8WmYJlGtWoQ
Date: Tue, 25 Jun 2013 17:55:27 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C54AF9@ORSMSX106.amr.corp.intel.com>
References: <20130621174057.GI22006@pd.tnic>
 <20130625174536.5226.66421.stgit@localhost.localdomain>
In-Reply-To: <20130625174536.5226.66421.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5PHtcGa030812

+/*
+ * Indicates MCA banks controlled by the current cpu for CMCI. Note that this
+ * can change when a cpu is offlined or brought online since some MCA banks
+ * are shared across cpus. When a cpu is offlined, cmci_clear() disables CMCI
+ * on all banks owned by the cpu and clears this bitfield. At this point,
+ * cmci_rediscover() kicks in and a different cpu may end up taking
+ * ownership of some of the shared MCA banks that were previously owned
+ * by the offlined cpu.
+ */
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);

Maybe an extra sentence or two at the beginning to say *why* we need this.
E.g.

/*
 * CMCI can be delivered to multiple cpus that share a machine check bank
 * so we need to designate a single cpu to process errors logged in each bank
 * in the interrupt handler (otherwise we would have many races and potential
 * double reporting of the same error.
 */
...

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
