Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaFMKGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:06:43 -0400
Received: from mx0.aculab.com ([213.249.233.131]:41640 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753151AbaFMKGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:06:40 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Geert Uytterhoeven'" <geert@linux-m68k.org>
CC: Tom Herbert <therbert@google.com>, "David S. Miller" <davem@davemloft.net>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [-next] Regression: ssh log in slowdown
Thread-Topic: [-next] Regression: ssh log in slowdown
Thread-Index: AQHPhuOEjg6tqmc0skKORvvtsE7uQJtuurFwgAABkQCAABGuYA==
Date: Fri, 13 Jun 2014 10:05:42 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725C2C3@AcuExch.aculab.com>
References: <alpine.DEB.2.02.1406130111280.1551@tomh.mtv.corp.google.com>
	<CAMuHMdW4kYeqEby3iABzdbjyAkPKq=x4dyopokFbHWT0Q4fjcw@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D1725C134@AcuExch.aculab.com>
 <CAMuHMdXOY8NF78gnpqHdNueDKDs5kTZ+xqV+dVXCYCu8MkSFng@mail.gmail.com>
In-Reply-To: <CAMuHMdXOY8NF78gnpqHdNueDKDs5kTZ+xqV+dVXCYCu8MkSFng@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5DA6oQZ013295

From: Geert Uytterhoeven
> Hi David,
> 
> On Fri, Jun 13, 2014 at 10:49 AM, David Laight <David.Laight@aculab.com> wrote:
> > From: Of Geert Uytterhoeven
> > ...
> >> Note that I'm also using NFS root, which doesn't seem to be affected.
> >> I can happily run "ls -R /" on the serial console during the 10 s delay in ssh.
> >
> > Are you sure that the delay during ssh login isn't just
> > a reverse DNS timeout?
> 
> Indeed, the ssh server sends a reverse DNS request twice, with 5s in between:
... 
> Interestingly, I don't see the forward DNS request after that, which
> does happen in the good case.

The forwards request is probably just copying some strange code from 'rshd'
that tried to verify the reverse lookup by doing a forwards lookup on the
result.
That in itself used to cause us grief.
The RDNS would (correctly) generate host.bar.baz.co.uk, since the 'domain'
in etc/resolv.conf was bar.baz.co.uk the forwards lookup first tried
host.bar.baz.co.uk.bar.baz.co.uk then host.bar.baz.co.uk.baz.co.uk
one of which always timed out :-(
(When the 'search' command was added we could avoid the request that
timed out.)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
