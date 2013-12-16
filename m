Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3LPSe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:34:59 -0500
Received: from ring0.de ([91.143.88.219]:44384 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab3LPSe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:34:56 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: marc.info]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 16 Dec 2013 19:34:50 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [RFCv4 06/11] misc: Introduce Nokia CMT driver
Message-ID: <20131216183448.GA10614@earth.universe>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux-OMAP <linux-omap@vger.kernel.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
 <1387150085-23173-7-git-send-email-sre@debian.org>
 <CACRpkdYjjXgE_W8gq1e6z=nGMF=r-m+o2kkvrBFrEMm3o0=RwQ@mail.gmail.com>
 <20131216121524.GA6177@earth.universe>
 <CACRpkdbx=Ye8xo4wMkyntME45xv15DeyqV32aeCAcSaa+vDpfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <CACRpkdbx=Ye8xo4wMkyntME45xv15DeyqV32aeCAcSaa+vDpfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 16, 2013 at 02:31:53PM +0100, Linus Walleij wrote:
> I am very reluctant in letting device trees specify exports of GPIOs
> to userspace, not so much because it's Linux-specific but for
> the fact that people are doing things in userspace that should not
> be done in userspace.
>=20
> Last time it was proposed I asked to the specific usecase,
> exactly why userspace needed this handle on a physical
> GPIO line, and why it can't use another userspace interface
> (example: leds, keys etc.)

There are a couple of lines ("cmt_apeslpx", "cmt_rst_rq", "cmt_en",
"cmt_rst", "cmt_bsi"), which are handled by ofono to do the correct
power sequence for the modem. The relevant ofono code is here:

https://git.kernel.org/cgit/network/ofono/ofono.git/tree/plugins/nokia-gpio=
=2Ec

In MeeGo etc. they have a little board specific init script, which
exports the gpio lines and setups some symlinks. IMHO at least the
board specific stuff should be handled by the kernel, thus I added
this code to the driver. I guess you prefer to move the power
sequencing completly to the kernel?

> > What do you think about the following?
> >
> > /*
> >  * driver, which provides generic reset notifications
> >  */
> > cmt_reset: reset-notifier {
> >     compatible =3D "linux,reset-notification";
> >
> >     interrupts =3D <gpio>;
> > };
>=20
> Looks good to me.

Ok :) I will prepare something for the next patch.

> > /*
> >  * driver, which exports the specified gpios in sysfs with the
> >  * supplied names. The device will be named according to the
> >  * label
> >  */
> > cmt_gpios: gpio-sysfs-export {
> >     compatible =3D "linux,gpio-sysfs-export";
> >     label =3D "nokia-cmt";
> >
> >     gpios =3D <A>, <B>, ...;
> >     gpio-names =3D "A", "B", ...;
> > };
>=20
> Please follow the discussion on this topic:
> http://marc.info/?l=3Dlinux-gpio&m=3D138201170431416&w=3D2

Ok.

> >> Why are you using a tasklet rather than a work
> >> for this?
> >
> > No particular reason. I just took this over from Nokia's code.
>=20
> Can you try to use a work instead?

Yes. I will have a look at this.

-- Sebastian

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSr0fIAAoJENju1/PIO/qabycP/AkF3r6cMXP4ws0yNciC4oUm
ciIG8wl9GVsERgkw7JNDKElpQEnAwfO2WkYLnTJmy/3s12jSqAUPj+12AwB56Oqk
8Nnnx93n8aGIe5QDu3NH9kj9Y0anhJN0hBgBz1emKZH4HXbWoZJsYRHndLTy6bgf
YTik0VsWxChGFrcoIAVHB+LZZ0GwI+nmhmmODk2li1ZHbB3dP04ZzYlmH8ekA31l
kjJrv+XQIwlVS+IkHFxVZbw1XTuU7q9vUFuWVj/wsDx0vL6q1WYpSwSPcH7G+/jT
iRNE+pAUdGxkkaz9Rom5GH3S1Bj2jrRzR4XxIt3QY0uyeTIX95Yq/uDa0epq+oEu
nJ6hUgOsDivNyAr5/9tvBk1u89AgFrmBLjJR7BpwWc1pjf7qM1jKEyp7LbnqmfjL
9tUTdz7Y4GFT2XA38BsLzu6NNG7QY+/klTvfiqrmrNLHyyPd+VoWg03C9ZzPI6mg
pa8KjJjiNfHwcgWuhTSW//qH2ljM5yyQHhcaJnQRmVqzlnI6jBymtUvYr2VZbIC5
2khMxehoxPNTi7QUZAwtssSZwvrk5hRODtxJ0ImsRs4lq6NeM+ncED9pPAa+gSaB
oOQI3Ka81yyqBvsxlSSX9gPkNV0clijbtAeQaeaPxAGEL74Zi4q2eYLLZBK4Wq9H
gVSlG22gFY06ifNi9nqA
=EBrD
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
