Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3FSTFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:05:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:64423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458Ab3FSTFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="319590758"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: RE: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Topic: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Index: AQHObRaMG8NLWdbwnkKYI9OOtTgcdZk9yhyA//+MXBCAAHyTAP//kUdQ
Date: Wed, 19 Jun 2013 19:05:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
In-Reply-To: <20130619183640.GL28300@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5JJ5V2U011990

> Why, fill out struct mce and do mce_log(mce) does not suffice?

There is (or should be) a lot more interesting stuff in the CPER than just the address. Stuff
that we don't have fields for in the existing mcelog structure.  We also need to treat filtered
records from modern APEI implementations a bit differently from the old stuff.  The original
user of this code was Westmere-EX, which used it as a workaround for a missing address in
MCi_ADDR for corrected errors.  So in that scenario we had every error being reported and
mcelog(8) deamon doing the threshold analysis to decide when to take action.

In this new modern world - Naveen wants to have the BIOS decide the threshold, so we'd
like Linux to take some action as soon as it sees just one CPER.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
