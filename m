Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3LSReo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:34:44 -0500
Received: from mx0.aculab.com ([213.249.233.131]:35320 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752148Ab3LSRel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:34:41 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 1/7] drivers: usb: Include appropriate header file in hcd.c
Date: Thu, 19 Dec 2013 17:33:09 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B74B9@saturn3.aculab.com>
In-Reply-To: <20131219165802.GA27639@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/7] drivers: usb: Include appropriate header file in hcd.c
Thread-Index: Ac78202ZHnawU2TzQRu7KKDUjB7w7gABFxfg
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com> <20131219163623.GB12255@kroah.com> <CAMpEsFGi7hj8EXUJ78zS0g6ZWRTW5FpGD5Q7tz1DgEJSNAWSZQ@mail.gmail.com> <20131219165802.GA27639@kroah.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rashika Kheria" <rashika.kheria@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Matthias Beyer" <mail@beyermatthias.de>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        "Josh Triplett" <josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJHYpLq006295

> > These warning are non-default GCC warnings. These can be seen either
> > by adding W=1 while running make (i.e. make W=1) or adding
> > -Wmissing-prototypes in KBUILD_CFLAGS in the toplevel Makefile.
> 
> By default, we don't care about 'W=1' warnings, as no one sees them, and
> they don't matter.

-Wmissing-prototypes really ought to be defined.

Some of the other warning are a little more pedantic, the most annoying
is -Wsign-compare.  OTOH a lot of code out there is clean enough to build
without any warnings and with a moderate amount of pedantry from the compiler.

OTOH just including extra headers isn't ideal - it can considerably
slow down the compilation time. There are many subsystems that don't
really separate their internal headers from their external ones.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
