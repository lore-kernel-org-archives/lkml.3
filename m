Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184Ab3GRQvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:51:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:17651 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3GRQvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:51:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,695,1367996400"; 
   d="scan'208";a="372639856"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Thread-Topic: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Thread-Index: AQHOfxrdPLmL8JP980CYV5tH00P+dJlhOAEQgAnqpoD//4vz4A==
Date: Thu, 18 Jul 2013 16:51:48 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C92B23@ORSMSX106.amr.corp.intel.com>
References: <51D9EAF3.4050804@tlinx.org>
 <CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
 <20130712080428.GB359@x4> <20130712134115.GI24008@pd.tnic>
 <51E00B55.5070003@infradead.org> <20130712142106.GJ24008@pd.tnic>
 <20130712131340.1a371662.mchehab@infradead.org>
 <3908561D78D1C84285E8C5FCA982C28F31C7D83C@ORSMSX106.amr.corp.intel.com>
 <20130718164215.GC15992@pd.tnic>
In-Reply-To: <20130718164215.GC15992@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6IGpvqG004638

+	BUG_ON(mci->mc_idx >= EDAC_MAX_MCS);

Do we have to "BUG_ON()" here?  Couldn't we be gentler with something like:

	if (mci->mc_idx >= EDAC_MAX_MCS) {
		printk_once(KERN_WARNING "Too many memory controllers\n");
		return; /* probably need to make sure caller copes with this ... so more stuff there */
	}

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
