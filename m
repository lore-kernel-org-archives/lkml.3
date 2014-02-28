Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaB1CYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:24:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53386 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaB1CYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:24:20 -0500
Date: Fri, 28 Feb 2014 11:23:59 +0900
From: Mark Brown <broonie@kernel.org>
To: nikesh@opensource.wolfsonmicro.com
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        nikesh <Nikesh.Oswal@wolfsonmicro.com>
Message-ID: <20140228022359.GD9383@sirena.org.uk>
References: <1393517900-27126-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u+M3zPFM/+rkulSy"
Content-Disposition: inline
In-Reply-To: <1393517900-27126-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.153
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASOC: dapm: add params_select callback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u+M3zPFM/+rkulSy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 04:18:20PM +0000, nikesh@opensource.wolfsonmicro.com wrote:
> From: nikesh <Nikesh.Oswal@wolfsonmicro.com>

As I said in my reply to your earlier patch:

| You need to fix both your git and e-mail setups, you should be using
| "Nikesh Oswal" or similar as your real name and more importantly your

Please don't ignore review comments, it tends not to be helpful.

Please do also use subject lines matching the style for the subsystem.

> dai-link params for codec-codec links were fixed. The fixed link between
> codec and another chip which may be another codec, baseband, bluetooth
> codec etc may require run time configuaration changes. This change
> provides an optional callback to select one of the param from a list
> of params.

OK, so the question now is why is this being done using a callback and
why is that callback picking from a list of predefined configurations?
You've not motivated this decision at all and it's not obvious to me
that it's the best approach (for example, why not just let the machine
driver set the parameters at any time rather than have it wait for a
callback)?

The picking from a list is especially odd, what I said in my previous
review was:

| If you look at the existing interface you'll also see that it takes an
| array of parameters rather than just a single parameter.  The idea was
| to extend the interface to provide a control to userspace allowing
| selection of one of the configurations from a list for use with cases
| like modems which can switch between 8kHz and 16kHz modes.

but if the selection is done purely in kernel space and we're not
constructing an enum then it's less clear that this is helpful.

--u+M3zPFM/+rkulSy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTD/M8AAoJELSic+t+oim9oYgP/iQ36X7Iay3g0P1IZOUK95wD
J9Rwo9j0Lm+L9O9injgQmjZxha2igCeeo7DoJVN6RuZ4Rj0jIteGtGKwxpK2JnMB
K971vQjWCnwlwbFewj3Cha0zIMxJSugxkGYSVTrwjQcQzjsOL/qUk68jyL/M6/Zf
NBbkc1RePGGzt1+v2w2PqWw5xGUnm3doIluTZCBS9KgxIpeqkP2S38a72vF5ACja
8XNvzgAkh5SOXssrwptqarpVxkz6jiEHpbZ2/tHqnJgdys8VvOKuakPd7IZVF3gf
zw9WdToORufdJLF4XObhOLjMJ7QV/yb+67vpCZvfneBFDqJrVNXeVzRvsi5xAY8w
ZKeZqZQM8U/BiA66/5MJZD9voQX6W2fGwcnl4MG/4+UesU6t1kEX5uRHwizCzp3N
74/hh5yOSxVgDANKGCmG82ds69gTCavsqto6LVIDMOEoM46ZO6M3kln7UIfhgHnq
mSpvocrzzBHExQGqRN3D1tqfKN+xNuwvIUH+zVaZUnGYDfPETOS2zyIEueWSXer1
8X8+aN7OsElaD1dySj9sTG3iSqoGF/qYNWof2tJ+pb3mobj14sdBi1Ex7E23SN9n
er2drZRTpqvwzg8RPXaDZbOYeZjptANYK8+/3HVpT5NFO/mrv4ZWsZjodC9SWAKY
+BLJwc7Gb/EefH3gHXDR
=3Iga
-----END PGP SIGNATURE-----

--u+M3zPFM/+rkulSy--
