Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412AbaKOAwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 19:52:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:41451 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbaKOAws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 19:52:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,388,1413270000"; 
   d="scan'208";a="637289352"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Ingo Molnar" <mingo@kernel.org>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Request for help: what did I do wrong with idtentry?
Thread-Topic: Request for help: what did I do wrong with idtentry?
Thread-Index: AQHQAFn9VKRGAKtP5EuVoKJutzATjZxg2SQQ
Date: Sat, 15 Nov 2014 00:52:46 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3293D455@ORSMSX114.amr.corp.intel.com>
References: <CALCETrXdaEYjjfsTYySDXZvBHON10-EQRftV-OSCWTKMsUfOtg@mail.gmail.com>
In-Reply-To: <CALCETrXdaEYjjfsTYySDXZvBHON10-EQRftV-OSCWTKMsUfOtg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAF0qtpM004606

> causes Tony's MCE stress test to fail, presumably when some CPU either
> becomes permanently non-interruptable or otherwise wanders off into
> the weeds.

It might be that recent "improvements" I made to my test harness have
messed things up.  I trimmed one delay (between injection and consumption),
but it turns out the other delay in the code never get executed (because we
take a SIGBUS on consumption and then longjmp).  So my test that used
to pause a bit between iterations were running almost back to back
consumption and injection of next error.

This meant the serial console was a huge bottleneck (especially as my
development BIOS is also kicking its own debug junk onto the same port).
Some of the errors pointed obliquely at console.

I've slowed things back down to where they used to be, and things are
ticking along nicely (with 0.6 second delay between iterations).  Just
passed the 2800 mark and still going.  I'm leaving it running over the
weekend - if it makes it into the 50k level I'm willing to call it good.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
