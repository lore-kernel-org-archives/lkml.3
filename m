Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3IES5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:57:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:51893 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab3IES5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:57:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,848,1371106800"; 
   d="scan'208";a="356479649"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lockref: remove cpu_relax() again
Thread-Topic: [PATCH] lockref: remove cpu_relax() again
Thread-Index: AQHOqjponYZ6pHUzoUeo27Wv6BHm9pm3utOA//+oSZCAAH9VgP//mtyg
Date: Thu, 5 Sep 2013 18:57:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CDCC23@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
	<CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
 <CA+55aFyevZQG5pEz-iJF6MFEMpwJD=biB-x852ki0spOM293Sg@mail.gmail.com>
In-Reply-To: <CA+55aFyevZQG5pEz-iJF6MFEMpwJD=biB-x852ki0spOM293Sg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r85IvGYu032277

> Also, it strikes me that ia64 has tons of different versions of
> cmpxchg, and the one you use by default is the one with "acquire"
> semantics

Not "tons", just two.  You can ask for "acquire" or "release" semantics,
there is no relaxed option.

Worse still - early processor implementations actually just ignored
the acquire/release and did a full fence all the time.  Unfortunately
this meant a lot of badly written code that used .acq when they really
wanted .rel became legacy out in the wild - so when we made a cpu
that strictly did the .acq or .rel ... all that code started breaking - so
we had to back-pedal and keep the "legacy" behavior of a full fence :-(

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
