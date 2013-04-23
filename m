Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3DWJA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:00:26 -0400
Received: from mx0.aculab.com ([213.249.233.131]:57519 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754760Ab3DWJAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:00:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: Unsigned widening casts of binary "not" operations..
Date: Tue, 23 Apr 2013 09:59:05 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B71EF@saturn3.aculab.com>
In-Reply-To: <CA+55aFy0jPr5udwJx8cZ-QFs-OgZzQ_NJm_VSj_cS7tsKUn3Kw@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Unsigned widening casts of binary "not" operations..
Thread-Index: Ac4/uYncWaABZOdZQnqoZ43QRKGmVwARvk/A
References: <CA+55aFwpLu0qNms=hkQr43yqD0K9DgESNm91OEWKT1ZuT8MU6Q@mail.gmail.com> <CA+55aFy0jPr5udwJx8cZ-QFs-OgZzQ_NJm_VSj_cS7tsKUn3Kw@mail.gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "David Miller" <davem@davemloft.net>, "Theodore Ts'o" <tytso@mit.edu>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3N90ZxA011544

> What happens is that the "~bitmask" is done in the *narrower* type,
> and then - because the narrower type is unsigned - the cast to the
> wider type is done as an *unsigned* cast, so what you *think* happens
> is that it clears the bits that are set in "bitmask", but what
> *actually* happens is that yes, you clear the bits that are set in
> :bitmask", but you *also* clear the upper bits of value.

If the narrower type is signed it is probably even more confusing!
The high bits will be preserved unless you are masking off bit 31.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
