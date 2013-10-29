Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3J2KZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:25:40 -0400
Received: from ring0.de ([91.143.88.219]:39506 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3J2KZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:25:37 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 29 Oct 2013 11:25:28 +0100
From: Sebastian Reichel <sre@debian.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-input@vger.kernel.org,
        "=?iso-8859-1?Q?=22'Beno=EEt_Cousson'=22?=" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
Message-ID: <20131029102527.GA10530@earth.universe>
Mail-Followup-To: Kumar Gala <galak@codeaurora.org>,
	linux-input@vger.kernel.org,
	=?iso-8859-1?Q?=22'Beno=EEt_Cousson'=22?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Russell King <linux@arm.linux.org.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
References: <1382446042-27099-1-git-send-email-sre@debian.org>
 <1382446042-27099-2-git-send-email-sre@debian.org>
 <5137C017-2515-427C-865F-B938CC24B210@codeaurora.org>
 <20131029010608.GA5353@earth.universe>
 <14DEC9DA-8C77-4F73-AF3A-6C0D20C6C1AB@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <14DEC9DA-8C77-4F73-AF3A-6C0D20C6C1AB@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2013 at 03:33:31AM -0500, Kumar Gala wrote:
> On Oct 28, 2013, at 8:06 PM, Sebastian Reichel wrote:
> > On Mon, Oct 28, 2013 at 01:42:47AM -0500, Kumar Gala wrote:
> >>> +This binding is based on the matrix-keymap binding with the following
> >>> +changes:
> >>=20
> >> Maybe be a bit more specific and say 'based on the input/matrix-keymap=
=2Etxt binding'..
> >=20
> > OK.
> >=20
> >>> + * keypad,num-rows and keypad,num-columns are required.
> >>=20
> >> Is linux,keymap required from matrix-keymap.txt?
> >=20
> > Yes, matrix-keymap.txt contains descriptions for the following:
> >=20
> > required:
> > - linux,keymap
>=20
> So you don't say that linux,keymap is required for twl4030-keypad
> (wasn't clear if you assumed that or not).

It's already required by matrix-keypad, so I assumed the requirement
is inherited by twl4030-keypad. The other matrix-keymap based
bindings assume the same.

keypad,num-rows and keypad,num-columns are only stated explicitly,
because they are optional in matrix-keymap, but required by
twl4030-keympad.

> > optional:
> > - keypad,num-rows
> > - keypad,num-columns
> >=20
> >>> +Optional Properties specific to linux:
> >>> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.
> >>=20
> >> Does it make sense to update the matrix-keymap.txt binding to add
> >> 'linux,keypad-no-autorepeat' there?
> >=20
> > At least according to devicetree documentation there are
> > keymap-matrix.txt based drivers, which do not support
> > "linux,keypad-no-autorepeat".
>=20
> Which is why it could be optional in keymap-matrix.txt.  I dont
> know anything about keymap/keypad's just asking the question?
>=20
> It seems as if linux,keypad-no-autorepeat is intended to mean the
> same thing (if relevant to the device) across all drivers.  Is
> that correct?  If so it seems like moving it to be specified in a
> generic input binding makes sense, just not sure if
> keymap-matrix.txt is that place or not.

Yes, when supported it means the same. I can add it to
keymap-matrix.txt.

-- Sebastian

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSb40XAAoJENju1/PIO/qahGoP/1DAToS7oOCrQFVKlQ52Wk7f
BV2abfnWS1wxzv4VL+PdWTF2uidtanqzyD5zAG1L9eOQct43gWZncpp0Pf2xsuZS
6NXQMov1g+qzO754EoShcC/Hefhu3zspxMFkckpdAG9R8Y0cQFqwscnnCBMLjCD9
YwxnCqCLA/k261FmjLmV3D/aS6IOnC9Htx1VVu0/BhUYJTt2d0jNxeUzV59XTz48
3p8Ib5ZxvtcV/nZgwH+UAPO5C8NuRurd3AabRLZz8W+2WlOnkEbDeUWmJyowIzNF
PoJYHgosqOHO/Zfbzaodl2F4ZjB9mQgPsWLqoA6c/mmPnbT80Tj1PHzBr9YoTqn9
zy6uVDf+kFU5HdJqatoOl4GQVWf+E2I5rxYc9FymXnejtQXpRkQ8+fs1mvZJ95zC
Ffbhl9Gh2ccPdXjEjntyvcGNgB8vr2rTAOLwzoJKZHOv7vKPA+Rcl5yXd7PK4eUy
y3J8NFlL5kwuWpfl1W+dwjl9DLE7x52WVAzUqZe7+XOYNoTTucZKsrT/ux1FI3+X
XE7ml3v5clvcuZAroSUVnfZRXsJvG5H7x9GGuJ9POu4M8DHr4l2Az3KLSWg5vr8h
aemiJ1mndAn8DPZJWx7woAWB5+Wm8JeVcN6/qfOAx1VOhMt+7uP+UFdZR4QQRj+S
ZEwcMTUhSYox1W5NA06T
=aZwS
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
