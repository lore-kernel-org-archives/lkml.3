Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3JJUCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:02:51 -0400
Received: from ring0.de ([91.143.88.219]:38210 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab3JJUCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:02:47 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: elinux.org]
Date: Thu, 10 Oct 2013 22:02:36 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        "'Pali =?iso-8859-1?Q?Roh=E1r'?=" <pali.rohar@gmail.com>,
        =?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [RFCv3 0/7] OMAP SSI driver
Message-ID: <20131010200236.GA6603@earth.universe>
Mail-Followup-To: Aaro Koskinen <aaro.koskinen@iki.fi>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Russell King <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?'Beno=EEt?= Cousson' <bcousson@baylibre.com>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org,
	'Pali =?iso-8859-1?Q?Roh=E1r'?= <pali.rohar@gmail.com>,
	=?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>,
	Tony Lindgren <tony@atomide.com>
References: <1381091235-18293-1-git-send-email-sre@debian.org>
 <20131008172815.GA8313@atomide.com>
 <20131010172128.GF28657@earth.universe>
 <20131010182801.GB29989@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20131010182801.GB29989@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2013 at 09:28:01PM +0300, Aaro Koskinen wrote:
> On Thu, Oct 10, 2013 at 07:21:30PM +0200, Sebastian Reichel wrote:
> > Any issues with this or any other suggestions how to proceed?
>=20
> Maybe you could provide some brief instructions/description of how this
> was tested?

Sure. I used Carlos' original patch, which has been tested to be
working. Then I checked with some debug prints and the debugfs
support what the registers and resources should look like.
Next I updated the patch to use the new kernel frameworks and
made sure everything is behaves as before.

For actually using the modem of the Nokia N900 three more drivers
are needed in the mainline kernel in addtion to this one:

1. cmt

 This is a small driver handling the modem's reset line, which
 is connected via a gpio pin to the system.

2. ssi_protocol
=20
 This is an hsi client driver, which actually talks with the modem
 and exports an phonet interface for userspace access. It makes
 use of the cmt driver.

 I plan on porting these to the new kernel frameworks next. If
 I'm not mistaken this should be enough to communicate with the
 modem.

3. cmt_speech

 This is an hsi client driver, which takes care of interchanging
 speech data with the modem. This one is needed for calling. I
 will have a look at it once the basic stuff is working.

P.S.: You can get a mainline kernel status matrix for the Nokia
      N900 on this page: http://elinux.org/N900

-- Sebastian

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSVwfcAAoJENju1/PIO/qaywsP/0tTaT+XX2/BpM8F97h3DtKU
wO283p1MHuec9tmAIRBtF7ppflPb4LEd6tIMmtVRjEuxjVTlKRLCTD83h8oUS+zq
/vfA8htcm5UBYu+uWadXtQa0tm1m3g+1KNROrLFK4wjQPEfIdFU8dGgFQFKMikI6
tOE4J6bihvd+vTjJLjzrKouNgJSm9QCooCeRIcJufV685BRjNvvS3N8xK9EYDGIj
Eor3k32aF72Yj5GwDJTDRs3T5La5JYJ5tu48OsI4LqkC2lZKoCe7fapRmx9OGSa4
FcNq7jy2cBC/Y0KTv56POmDqQN+OqZmDf7s996CUwNUBkADE2eKq33RQ2Pq0Uary
D5/dTEqQcCUmpuKu71aKwHJIy8ZZv3anOBb3PZiYbPw5984oRYUgpuSomd2AjRot
jx2X2yPRnJxWCoZnbAvTSIjuoA54SViXlD3CtQD3gjgylXtFDMC4AapxQl7BlEkJ
xVgj/cA0I+ZKjtU3DM7YE0XSDz+cwuA4sHP9RPKRfunxvFp/SYpRy9HCIoUy660N
xRXWznOqmifzrgZ2JIXv4vJl60t9yfOT3UZmlVfTCKgmJm2/VUHC00hIeLyE4Snm
rb/XPqd537OdOObtXxQeAlklTK7WmbheRzO4tfCOje6ohpkLUNUlpJ6AIuUn9dWQ
f7yor2YZuWaNh4jVoO5B
=9zts
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
