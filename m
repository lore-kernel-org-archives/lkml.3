Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaKDU2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:28:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37897 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:28:00 -0500
Date: Tue, 4 Nov 2014 20:26:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141104202638.GZ3815@sirena.org.uk>
References: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <1415083845-27079-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hZpDuTGHUtM8eGVR"
Content-Disposition: inline
In-Reply-To: <1415083845-27079-1-git-send-email-mike.looijmans@topic.nl>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hZpDuTGHUtM8eGVR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 07:50:45AM +0100, Mike Looijmans wrote:

> v3: Add .of_match_table and prefix lltc
>     Clarify why regmap cannot be used
>     Add lltc,operating-mode (0..3) DT property
>     regulator child nodes are optional

Leave out the mode setting in the DT for now please, Javier was looking
at adding a standard property for this with a driver defined mapping to
modes - you should implement the standard get_mode() and set_mode() (but
can always do that as a followup).

> +/* the LTC3562 does not have a register map, instead it receives a two-byte
> + * command set. The first byte sets the mask for the output(s) to be programmed
> + * and the second byte hold the "enable" bit and the DAC code. */
> +struct ltc3562_status {
> +	u8 addr_mode;	/* sub-address byte: program mask an operating mode */
> +	u8 enable_daccode;	/* data byte: Enable bit and DAC code  */
> +};

So, I managed to find a datasheet[1] and this does actually seem to be a
standard register map.  It looks like this is a 4x12 register map with
the program bytes being essentially register addresses (called sub
addresses in the datasheet), two pad bits (normally we'd include these
in the data for convenience) and the rest of the bits data.  What am I
missing here?

Otherwise this looks good.

[1] http://cds.linear.com/docs/en/datasheet/3562fa.pdf

--hZpDuTGHUtM8eGVR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWTZ+AAoJECTWi3JdVIfQW9cH/3TJyVExD9HWZyO+/Edo65sq
8X60hJTAruzuiNA+rlLTaerhoBCuBgJh9Lq1A96fumwS2PbeM2zvYi4Z1GOZeQc7
jTqW3aj5v95QLS4KypKaEo5kDG/5nKbkjDrq0EiKnRvcjM5N82p+xxl7m1D1t8yR
EDpnE66lSOgBr90+ZMTcMsUbBFmysCX/GLMQglg/B12n947xbK0pKqpyRUSdOCHY
MgAxMXtDlPyjP2fVaJGXt4TNcbllkTyO5tM4wrJLLt1DaaZUsZftAA/pa2y3wchA
BP7hrGHcFbXs0yhy9qn82PUReGVb7ssir5G1s68o68/X1yYmY6kVxHcFZ74e9P8=
=xjJm
-----END PGP SIGNATURE-----

--hZpDuTGHUtM8eGVR--
