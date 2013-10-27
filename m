Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3J0Lkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:40:33 -0400
Received: from ring0.de ([91.143.88.219]:58315 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3J0Lkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:40:31 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 27 Oct 2013 12:40:26 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-input@vger.kernel.org, "'Beno?t Cousson'" <bcousson@baylibre.com>,
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
Message-ID: <20131027114026.GB14091@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>, linux-input@vger.kernel.org,
	'Beno?t Cousson' <bcousson@baylibre.com>,
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
 <20131027111715.GA2437@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20131027111715.GA2437@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Sun, Oct 27, 2013 at 12:17:15PM +0100, Pavel Machek wrote:
> > Add device tree support for twl4030 keypad driver and update the
> > Documentation with twl4030 keypad device tree binding information.
> >=20
> > Tested on Nokia N900.
>=20
> It looks pretty good.

Thanks.

> > + * keypad,num-rows and keypad,num-columns are required.
> Is "keypad," prefix neccessary here?

See Documentation/devicetree/bindings/input/matrix-keymap.txt

> > +Optional Properties specific to linux:
> > +- linux,keypad-no-autorepeat: do no enable autorepeat feature.
>=20
> "do not autorepeat". Plus I do not see what is Linux specifc about not
> autorepeating... Other systems will likely know about autorepeat, too.

This property has already been used like this for
samsung-keypad, stmpe-keypad, omap-keypad and
gpio-matrix-keypad.

> > +#if IS_ENABLED(CONFIG_OF)
> I'm probably missing something here, but why not #ifdef CONFIG_OF?

I have been told for other drivers, that IS_ENABLED() is
the prefered way to check for configuration these days.

> > @@ -381,7 +426,7 @@ static int twl4030_kp_probe(struct platform_device =
*pdev)
> > =20
> >  	input_set_capability(input, EV_MSC, MSC_SCAN);
> >  	/* Enable auto repeat feature of Linux input subsystem */
> > -	if (pdata->rep)
> > +	if (!kp->no_autorepeat)
> >  		__set_bit(EV_REP, input->evbit);
> >
>=20
> Double negation is nasty to read. I believe code would be more
> readable if you switched logic to kp->autorepeat.

I was thinking about the same when writing it, but decided
against it, since it will just move the double negation to
the variable initialization.

-- Sebastian

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSbPupAAoJENju1/PIO/qaIFAQAIxtcXUK0WX62Y5lL0/2VNJh
m+7Wn3q0Z1zKi4JVrOQNkY3a1xMTZsDAreVahcEifgPQr+iY8zXh9WH8+H9V0poK
G912yCnySvAc571d43VxCnKkqloyi/fV12AlYao1Aa9r0Hbhp/61CC9BL7jyj15x
aQZAoEJq8DUhAo1/6zCw82LLOP6El36SODkDhJYjdyDfToQVp5lTkqO215e1Nfj2
bzdTvL7vEadRwvK3ifNUqJDHbDMITwabKG05z/Yw7jiDUPxRXzd5NJ5/N9K1hVM8
XaH8JdXT4zYZQZTbGNiCKiEAbauHhuhA3R915ykQhwL1uU8a2GU9CavZhGtR7Cf1
l6ntlnAeuUhzXdZH+xJeY3BH8daOf73TrbJDA4zWOivy0ca3ze+EYVmY7SGgdoY+
59igSbOoFKSh8rIdCB6GiGtGY6bB+jU5cij7TV4NH5VbergWhX2EegXyhTy8APJf
iRRyTkpHSjXlvz8WB++kVET9PycIi4p41uvU2TYu9JT0xpLMwDbbOZkQLpYBuA3B
KnEvLagdczDgnNKFTH2miNZroqE5oBH+z8L05iRkaN9wD8+TGPp0wEScWH/Y2uO0
MZamA6FkFs4dyPjMASTwKWSUCWQrF3I1r9WK5atOsApRxlhcqOpTbY8QsDaTFw1I
KbvJJrrmFZTYtmBonIHc
=68OJ
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
