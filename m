Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaHDOlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:41:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45793 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaHDOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:41:16 -0400
Date: Mon, 4 Aug 2014 15:40:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Kevin Hilman <khilman@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Andy Green <andy.green@linaro.org>
Message-ID: <20140804144038.GQ30458@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
 <1406896365-4971-1-git-send-email-jaswinder.singh@linaro.org>
 <20140801184314.GM30458@sirena.org.uk>
 <CAJe_ZhdNjH+eyxMfpAw8Zg1SeZa1qh2ouMnTSress+6Gyr+5qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z5jwahX8Ql4zxomt"
Content-Disposition: inline
In-Reply-To: <CAJe_ZhdNjH+eyxMfpAw8Zg1SeZa1qh2ouMnTSress+6Gyr+5qA@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.223
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv10 4/4] dt: mailbox: add generic bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z5jwahX8Ql4zxomt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 02, 2014 at 01:17:18PM +0530, Jassi Brar wrote:
> On 2 August 2014 00:13, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, Aug 01, 2014 at 06:02:45PM +0530, Jassi Brar wrote:

> > Can I suggest that if we do want to avoid strings for some reason (it's
> > not obvious to me why)

> The string and index are both to be taken from DT node of client.

>     pwr_cntrl: power {
>                ...
>                mbox-names = "pwr-ctrl", "rpc";
>                mboxes = <&mailbox 0
>                        &mailbox 1>;
>     };

> The xlate() will map string onto index. So rather than the client
> driver specify, say, "rpc" while requesting mailbox channel, it can
> directly specify index 1.

The whole point with specifying an array of names as well as the array
of mboxes is that you don't then need to do that in the driver code, it
provides a layer of indirection between the array indexes and the
identification of the resources.  This improves the legibility of the
driver (since you're asking for things by name rather than random
number) and DT (since there's a bit less of counting through potentially
long lists and making sure you edit the right entry.  It also makes life
easier if a future version of the binding allows one of the existing
mailboxes to be omitted since you don't need to have blank entries.

> > then we include a recommendation to provide
> > defines in a header file in order to improve legibility.  That's pretty
> > minor, though.

> Sorry I don't understand.

If there's defines in the DT header files (which would hopefully go
along with the bindings in some future where we actually split the
bindings out) then the driver can use those names rather than having
numbers in it.

While I think about it it would be good to be able to encourage people
to have things like <&mailbox 0> being able to be written as <&mailbox
NAME>.

--z5jwahX8Ql4zxomt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT35tjAAoJELSic+t+oim9uJwQAI/S+qg2g/1POllj6SzxMit0
KV79H8ZM3OVZ3evccEWiP7xgOWwwkQNG5FNyGM+4pcTVNgk1IQ8jsxdFbA553Lh0
8cTAYKrNd+6Ukx0B9ofWg156qddkT15CHnfAa0n3rHq9vh0oP4PWhM9yii2O9b14
6DUyEVUSG+0DhX2sDr7s4ZKFvHrUwbw9COMht3NBmexTBdXNboOrybxh6OQa+2SR
LyzqNltsldTJ+zYzPBcFTVyPeiZc5T+fgg+/yay+34J2U/6KXPWeoGYVGXk6n7ID
jb3oxfou4Ke0ZFjrnjB2TBVIr1Wl2vyy1AhROUnbMKM5dEuG5D0dymlLNXW7JKlq
BSqM0y30bJK2AgMTaoOo1iXbA6Z6piiOppUojfno7+Y1403j+JyVeyHJAYArAnoR
3rSXOdZuVIS9evJ6IBT9eC6c5Zwq+N4jSb4PIP70/ik8Z9GFc0dHif73T2h3fByv
2z1HpiTRCsQRgPitPHen+ScSnn8Ozhh7yxpK56Rqzw1qh+NLxtNWsJ8syepFc5AP
aEjkGFjc2dODIebuYGHRJiTBnFKzCbaezrahVR3ZsiL/i/PLkWB0RPna1EXGjeQT
JBOasQ38smaStGLeYHwKCx+5z2zCo33iEyR0lMrNXHD30ALRgg7MBxefrquIbkhy
QpVlunIFoy1/8sgCWp+1
=fYsK
-----END PGP SIGNATURE-----

--z5jwahX8Ql4zxomt--
