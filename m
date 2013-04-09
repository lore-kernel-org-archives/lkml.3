Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab3DISbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:31:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:25199 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761628Ab3DISbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:31:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="319863340"
From: "Luck, Tony" <tony.luck@intel.com>
To: Khalid Aziz <khalid.aziz@oracle.com>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86, mce: Print warning if MCE handler fails to
 register /dev/mcelog
Thread-Topic: [PATCH] x86, mce: Print warning if MCE handler fails to
 register /dev/mcelog
Thread-Index: AQHONU70l3YN7SGlE0G+l1ZmHGabcJjONMgg
Date: Tue, 9 Apr 2013 18:30:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1EA41C2B@ORSMSX104.amr.corp.intel.com>
References: <1365531571.8447.4.camel@concerto>
In-Reply-To: <1365531571.8447.4.camel@concerto>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r39IVims006325

-	misc_register(&mce_chrdev_device);
+	if (misc_register(&mce_chrdev_device) != 0)
+		pr_warn("Failed to register mcelog device\n");

Did this actually happen to you?  Or is this just "good practice" to check the
return value from misc_register?

If this can really happen, we should remember that it failed and
just drop out of mce_log() early (no point in queueing up records
when there is no way for a user to ever access them).

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
