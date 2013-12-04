Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab3LDQNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:13:48 -0500
Received: from mx0.aculab.com ([213.249.233.131]:60689 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932872Ab3LDQNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:13:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: Supporting 4 way connections in LKSCTP
Date: Wed, 4 Dec 2013 16:12:58 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B745E@saturn3.aculab.com>
In-Reply-To: <529F4D1A.3050304@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Supporting 4 way connections in LKSCTP
Thread-Index: Ac7xBzSdouljlxP9RNmIdzUuyyhENQAAzTEQ
References: <CAFXGft+CXk3W8=3w=AuYzqYtYnR8nH4Of9=668tUeT+tugD9-A@mail.gmail.com>	<CAFXGftLsKm9a5bmXX4Fe+rnSvYVdBDOyYGwisRP7XMu+ky=DGw@mail.gmail.com>	<CAFXGftLt1p6XpR2eGsMYKjEbbOHvch-LgcFw1sAXThcA2Rtjyw@mail.gmail.com>	<20131127124530.GA23369@hmsreliant.think-freely.org>	<CAFXGftJQV=5Pqs3bhfiS3T1VO1q8jfaMjAUiqm2tDbtSyBCM3A@mail.gmail.com>	<529C9B50.50002@gmail.com>	<CAGugRbXFirQ5P3ek9zN86h4vvO6qsy3eNEooJOApotA+dL+C_g@mail.gmail.com>	<529CB859.9090904@gmail.com>	<CAFXGft+F52p+oaa59=5e5pGfON44N36NA-XMYi5PorzWeybnKw@mail.gmail.com>	<CAFXGft+4o6fT4SYbu3musC+-BEi=xOEGUbZSavF1-0_V1mg6zg@mail.gmail.com>	<529D3BF9.3070208@gmail.com>	<CAFXGftJtCCJ=pVxg_DH-+n2bKmoKXavog0y8mfX+h-1z3hP49Q@mail.gmail.com>	<529DCF42.1070800@gmail.com>	<CAFXGftK5tz90OzObiV7Hi+g080j3zWCNdo217CKdNkOY4JWQUg@mail.gmail.com>	<529DF73E.7060604@gmail.com> <CAFXGftKZD0zN1S=UTa_bYr71-v=7mzU=_CewTNkjPv9CGGB_Fg@mail.gmail.com> <529F395B.9040308@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B745D@saturn3.aculab.com> <529F4D1A
	.3050304@gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Vlad Yasevich" <vyasevich@gmail.com>, "Sun Paul" <paulrbk@gmail.com>
Cc: <netdev@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
        "Karl Heiss" <kheiss@gmail.com>, "Neil Horman" <nhorman@tuxdriver.com>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB4GDtdO002244

> > There are some network configurations that do cause problems.
> > Consider 4 systems with 3 LAN segments:
> > A) 10.10.10.1 on LAN X and 192.168.1.1 on LAN Y.
> > B) 10.10.10.2 on LAN X and 192.168.1.2 on LAN Y.
> > C) 10.10.10.3 on LAN X.
> > D) 10.10.10.4 on LAN X and 192.168.1.2 on LAN Z.
> > There are no routers between the networks (and none of the systems
> > are running IP forwarding).
> >
> > If A connects to B everything is fine - traffic can use either LAN.
> >
> > Connections from A to C are problematic if C tries to send anything
> > (except a HB) to 192.168.1.1 before receiving a HB response.
> > One of the SCTP stacks we've used did send messages to an
> > inappropriate address, but I've forgotten which one.
> 
> I guess that would be problematic if A can not receive traffic for
> 192.168.1.1 on the interface connected to LAN X.  I shouldn't
> technically be a problem for C as it should mark the path to 192.168.1.1
> as down.  For A, as long as it doesn't decide to ABORT the association,
> it shouldn't be a problem either.  It would be interesting to know more
> about what problems you've observed.

It was a long time ago, we don't actually do much SCTP testing even though
our product (SS7 M3UA) uses it. Mostly because we don't want to find
bugs that are hard to fix!

What we saw was C using the 192.x address (as supplied in the INIT) and
these not being routable to A (and not getting a response from a 3rd system).
So the application layer immediately timed everything out.

What I can't remember is whether this was Linux, Solaris or the SCTP stack
we took from freebsd and rammed into the windows kernel.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
