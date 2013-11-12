Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3KLDZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 22:25:20 -0500
Received: from ring0.de ([91.143.88.219]:43897 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3KLDZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 22:25:15 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 12 Nov 2013 04:25:09 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] Input: twl4030-keypad - add device tree support
Message-ID: <20131112032506.GA30028@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1383948866-32672-1-git-send-email-sre@debian.org>
 <1383948866-32672-2-git-send-email-sre@debian.org>
 <20131111221941.GB23331@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20131111221941.GB23331@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 11, 2013 at 11:19:41PM +0100, Pavel Machek wrote:
> > +	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
> > +		keypad_data->no_autorepeat =3D true;
>=20
> From 2/2:
>=20
> +Optional Properties specific to linux:
> +- linux,keypad-no-autorepeat: do not enable autorepeat feature.
>=20
> I'm confused now.

good catch! That happens when one tries to mimic other drivers :/

I just checked all DT input drivers for autorepeat keyword:

DRIVER              CODE                        DOCUMENTATION
twl4030-keypad      linux,input-no-autorepeat   linux,keypad-no-autorepeat
omap4-keypad        linux,input-no-autorepeat   linux,keypad-no-autorepeat
samsung-keypad      linux,input-no-autorepeat   linux,keypad-no-autorepeat
stmpe-keypad        st,no-autorepeat            st,no-autorepeat
spear-keyboard      autorepeat                  autorepeat
tca8418-keypad      keypad,autorepeat           --- not documented ---
gpio-matrix-keypad  linux,no-autorepeat         linux,no-autorepeat
gpio-keys-polled    autorepeat                  autorepeat
gpio-keys           autorepeat                  --- no documentation ---

Any suggestions how to continue fixing this mess? I guess first of
all the documentation of omap4-keypad, samsung-keypad and of course
the new twl4030-keypad driver should be fixed.

Next it would be nice to choose one standard property name for this
and use it for twl4030-keypad. I suggest to use "linux,input-no-autorepeat".

-- Sebastian

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSgZ+SAAoJENju1/PIO/qa50wQAJPVoA4kDTM/usZdzCF5AJPO
rwMTrILKtlDtR2kwaMDe8ihnmwRE4zdZonD7WYTPDgAzvwc6eIQx+XI//dtd8osz
phzXSAugaBrvERGIYemFv+gIrkYQqFOmEbSakFmnNlGzvD/ArkHjKqfzcMx8Zb/y
CQ6mAVpMzya80PWL5/omC09O9GIx8B7LIP/MYnB8G/S9r9n8AxS7DFKv3Fs5FAWF
qRjKuzN9O/VD0BP3DkeR8dmQTMc3QjFfl9bvPTGGwaaU5RaCsGQt2JkvgvyR/lfi
TnNpyh3QIt1OAZd1nm1BTw5dhGo0grHRdxtvYIHNIoXRksMIqsMQW9BPqigkHgwR
Lj/hyOcy2tBXYroUMRX9+yEi6DhjbWin+2fFTGcNpZfKj+ljz4HdeDEFiB3oICep
JMlDq2R4QVQsek3eYE8FtmbD6psF951uTiGjVEojqgxP4qL8m/VkTP9xv7/5TCNj
rZfKUwnivHOa6TCu+RcklUgsC4rt7Z2wY3Hb0m6VbWJPrQWovwRoqe6Tu4FmQc2J
Op1tBkVgaR19tt+qWUgDZvOFh6hP4dchR38GMa/cK+ZYW9o3CkUWxxsuIQGXss1o
GKEFxLDkV+Y4ZPp/OwuncSVDYqWzJAxj1KTf9UOhB4WyNqAXgSirKMXW06Qk9ZbZ
3D197nmfh91PeI33FXoV
=nJlz
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
