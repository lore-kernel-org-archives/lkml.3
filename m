Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaFQLFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:05:06 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47839 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753173AbaFQLFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:05:01 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Peter Hurley'" <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: RE: [PATCH tty-next 14/22] tty: Remove
 tty_wait_until_sent_from_close()
Thread-Topic: [PATCH tty-next 14/22] tty: Remove
 tty_wait_until_sent_from_close()
Thread-Index: AQHPihrgwgSnyL5/CECAg051obYgppt1Ircg
Date: Tue, 17 Jun 2014 11:03:50 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725DAF6@AcuExch.aculab.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
 <1402924639-5164-15-git-send-email-peter@hurleysoftware.com>
 <4575870.N9RCpZ4UMg@wuerfel> <53A01F02.7000202@hurleysoftware.com>
In-Reply-To: <53A01F02.7000202@hurleysoftware.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5HB5Nix006369

From: Peter Hurley
...
> > I don't understand the second half of the changelog, it doesn't seem
> > to fit here: there deadlock that we are trying to avoid here happens
> > when the *same* tty needs the lock to complete the function that
> > sends the pending data. I don't think we do still do that any more,
> > but it doesn't seem related to the tty lock being system-wide or not.
> 
> The tty lock is not used in the i/o path; it's purpose is to
> mutually exclude state changes in open(), close() and hangup().
> 
> The commit that added this [1] comments that _other_ ttys may wait
> for this tty to complete, and comments in the code note that this
> function should be removed when the system-wide tty mutex was removed
> (which happened with the commit noted in the changelog).

What happens if another process tries to do a non-blocking open
while you are sleeping in close waiting for output to drain?

Hopefully this returns before that data has drained.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
