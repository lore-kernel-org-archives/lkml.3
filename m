Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaKURU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:20:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:12851 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbaKURU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:20:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="419881252"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, rui wang <ruiv.wang@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: RE: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Topic: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Index: AQHQA9xP2DKrYSRRjki1N/RiQcamCZxoRecAgABTjfCAATqkgIAA/RuAgAEBPQD//4MAkA==
Date: Fri, 21 Nov 2014 17:20:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
 <20141121164140.GA4274@pd.tnic>
In-Reply-To: <20141121164140.GA4274@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sALHL516019491

> leave them in. Then you can read them out again on panic time. The mce
> log buffer will have to become a circular buffer or something like that.

This is a mixed bag.  If there are a bunch of errors so that we overflow the buffer,
then general wisdom says that people want to see the first errors, as the later
ones may just be secondary effects from the earlier ones.

But - lots of systems don't run mcelog(8) daemon.  So the buffer just fills
up with the first 32 errors (perhaps all relatively harmless corrected errors)
and then when some serious stuff happens we have no place to log :-)

Perhaps we need separate buffers for UC=0 and UC=1?  Or something else??

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
