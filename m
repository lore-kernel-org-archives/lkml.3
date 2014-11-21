Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaKUWA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:00:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:55912 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaKUWAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:00:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,433,1413270000"; 
   d="scan'208";a="636154996"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: rui wang <ruiv.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: RE: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Topic: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Thread-Index: AQHQA9xP2DKrYSRRjki1N/RiQcamCZxoRecAgABTjfCAATqkgIAA/RuAgAEBPQD//4MAkIAAlq0A//+wGfCAAIhmgP//fr/Q
Date: Fri, 21 Nov 2014 21:59:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32950618@ORSMSX114.amr.corp.intel.com>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
 <20141121164140.GA4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
 <20141121181334.GC4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329504FD@ORSMSX114.amr.corp.intel.com>
 <20141121213547.GF4274@pd.tnic>
In-Reply-To: <20141121213547.GF4274@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sALM0c7E021540

>> That means there were no VALID=1, EN=1, S=1 errors anywhere.  But there
>> might be some other things logged that would help us understand.
>
> By "other things" you mean other MCEs?

Logs with EN=0 and/or S=0.  They may have interesting information, and have
a good chance of being useful (especially if they are from some functional
unit that isn't part of the buggy behavior. Bad data flowing through multiple
functional units can leave a trail of logged entries (perhaps as many as four
units may see and log a single error). Only one of them should signal the machine
check (to avoid shutdown because of nested machine check). 

> Oh, cpu errata. So this would mean that we can't even rely on the
> contents of the MCA banks, can we?
>
> In any case, is any of the information in the MCA banks in such cases
> even usable then? Because if not, we're definitely barking up the wrong
> tree...

See above - I think even if there is a bug in the core that isn't setting the
right bits in the MCi_STATUS register - we could get good data from
devices out in the uncore.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
