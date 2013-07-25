Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3GYSDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:03:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:20303 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab3GYSDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:03:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,744,1367996400"; 
   d="scan'208";a="376059376"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>
CC: "bp@suse.de" <bp@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
Thread-Topic: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
Thread-Index: AQHOiSMYpPjuX7YEhUa+bD/+CCcJ8Jl1roDA
Date: Thu, 25 Jul 2013 18:01:33 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C9F32B@ORSMSX106.amr.corp.intel.com>
References: <20130724061626.GA18995@gchen.bj.intel.com>
 <20130725103647.5009.92648.stgit@localhost.localdomain>
In-Reply-To: <20130725103647.5009.92648.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6PI3vWZ005909

	MCESEV(
+		PANIC, "Action required but kernel thread is not continuable",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR, MCI_UC_SAR|MCI_ADDR),
+		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, MCG_STATUS_RIPV|MCG_STATUS_EIPV),
+		KERNEL
+		),
+	MCESEV(
 		AR, "Action required: data load error in a user process",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		USER

This just gives us a better panic message. Right?  Without this we'd keep walking the
severity table until we hit the "Action required: unknown MCACOD" entry which will
match and force a panic anyway.

So I might look for better wording.  As far as the h/w is concerned the thread is continuable.
Linux is just not smart enough (yet) to take the required recovery action.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
