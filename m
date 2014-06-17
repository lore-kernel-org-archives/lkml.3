Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaFQITT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:19:19 -0400
Received: from mx0.aculab.com ([213.249.233.131]:44097 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752816AbaFQITQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:19:16 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Karsten Keil <isdn@linux-pingi.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: RE: [PATCH tty-next 14/22] tty: Remove
 tty_wait_until_sent_from_close()
Thread-Topic: [PATCH tty-next 14/22] tty: Remove
 tty_wait_until_sent_from_close()
Thread-Index: AQHPigK/wgSnyL5/CECAg051obYgppt09HQw
Date: Tue, 17 Jun 2014 08:18:03 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725D868@AcuExch.aculab.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
 <1402924639-5164-15-git-send-email-peter@hurleysoftware.com>
 <4575870.N9RCpZ4UMg@wuerfel>
In-Reply-To: <4575870.N9RCpZ4UMg@wuerfel>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5H8JPoT005417

From: Arnd Bergmann
> On Monday 16 June 2014 09:17:11 Peter Hurley wrote:
> > tty_wait_until_sent_from_close() drops the tty lock while waiting
> > for the tty driver to finish sending previously accepted data (ie.,
> > data remaining in its write buffer and transmit fifo).
> >
> > However, dropping the tty lock is a hold-over from when the tty
> > lock was system-wide; ie., one lock for all ttys.
> >
> > Since commit 89c8d91e31f267703e365593f6bfebb9f6d2ad01,
> > 'tty: localise the lock', dropping the tty lock has not been necessary.
> >
> > CC: Karsten Keil <isdn@linux-pingi.de>
> > CC: linuxppc-dev@lists.ozlabs.org
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> 
> I don't understand the second half of the changelog, it doesn't seem
> to fit here: there deadlock that we are trying to avoid here happens
> when the *same* tty needs the lock to complete the function that
> sends the pending data. I don't think we do still do that any more,
> but it doesn't seem related to the tty lock being system-wide or not.

While I've not looked at the code in question; my thoughts were that
holding any lock while waiting for output to drain (or anything else
really) probably isn't a good idea.
You might find that something else needs the lock - even if only
some kind of status request.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
