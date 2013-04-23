Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3DWP0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:26:08 -0400
Received: from mx0.aculab.com ([213.249.233.131]:37681 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756758Ab3DWP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:26:06 -0400
Content-class: urn:content-classes:message
Subject: RE: Unsigned widening casts of binary "not" operations..
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Date: Tue, 23 Apr 2013 16:24:33 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B71F2@saturn3.aculab.com>
In-Reply-To: <CA+55aFwogFL=nm=YHwARcz9OTRBdWEDPG0xcqM-H3k-VZTOZPQ@mail.gmail.com>
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Unsigned widening casts of binary "not" operations..
Thread-Index: Ac5ALs8w5qoe3bp8SBuK5Vkhno/mjQABy1eQ
References: <CA+55aFwpLu0qNms=hkQr43yqD0K9DgESNm91OEWKT1ZuT8MU6Q@mail.gmail.com><CA+55aFy0jPr5udwJx8cZ-QFs-OgZzQ_NJm_VSj_cS7tsKUn3Kw@mail.gmail.com><AE90C24D6B3A694183C094C60CF0A2F6026B71EF@saturn3.aculab.com> <CA+55aFwogFL=nm=YHwARcz9OTRBdWEDPG0xcqM-H3k-VZTOZPQ@mail.gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "David Miller" <davem@davemloft.net>, "Theodore Ts'o" <tytso@mit.edu>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3NFQX8W013713

> > If the narrower type is signed it is probably even more confusing!
> > The high bits will be preserved unless you are masking off bit 31.
> 
> Yes. However, that case doesn't trigger with the normal case of small
> values. So "~4" works fine with widening, in a way that "~4u" does
> not.

Thinks ... converting:
	foo &= ~bar;
to:
	foo = ~(~foo | bar);
would generally DTRT.
Whether the compiler has the relevant patterns to optimise
it is another question.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
