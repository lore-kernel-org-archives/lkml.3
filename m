Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaA1KlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:41:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42896 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbaA1KlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:41:19 -0500
Message-ID: <52E78930.8080607@ti.com>
Date: Tue, 28 Jan 2014 12:40:48 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH] clk: divider: fix rate calculation for fractional rates
References: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com> <20131106111534.GW16735@n2100.arm.linux.org.uk> <527A2C9C.4080409@ti.com> <20131106161911.GA16735@n2100.arm.linux.org.uk> <52E76E3A.8030807@ti.com> <20140128103253.GD15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140128103253.GD15937@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Ehc4EMEa7p1Th0PQu8pK1JTudajJpOUri"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Ehc4EMEa7p1Th0PQu8pK1JTudajJpOUri
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-28 12:32, Russell King - ARM Linux wrote:

>> Why I'm asking this is that for me (and probably for others also if
>> you've seen it used in the kernel code) it feels natural to have code =
like:
>>
>> 	rate =3D clk_round_rate(clk, rate);
>> =09
>> 	/* Verify the rounded rate here to see it's ok for the IP etc */
>>
>> 	/* The rate is ok, so set it */
>> 	clk_set_rate(clk, rate);
>=20
> If you want to do something with the rounded rate, then that's fine,
> you have a reason to do it this way.  However, what I was referring to
> are drivers which literally do this:
>=20
> 	clk_set_rate(clk, clk_round_rate(clk, rate));

Thanks for clarification. Agreed, that's pointless. I gave the sequence
in the patch description just as an example for the sake of discussion
about the bug.

I didn't realize people actually do that in real code =3D).

 Tomi



--Ehc4EMEa7p1Th0PQu8pK1JTudajJpOUri
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS54kwAAoJEPo9qoy8lh71xzkQAK9PoOjLYxTZtWIJXlJeo3/w
dklE7H3EC9zY6JikeovdkHjhfrCv4y+MLUyE3AX7x05yrl4xUNUs+MNvHGuzX0nQ
NTcL65nHWc45IaXFKGatIc2w6Ke89j/3jfmHyWiwp65yowQ4oNdNX2xJok3ljOLG
dtm8RTxdEinxgU4AAo9BIKoxyKaxmFna3reNvy2CZ/TqQpqksRRW04CMA1mSW1sr
AYjoJq1N/W5fFAcJgN7RE7k3Hqq2eIcixCNoAxT1m10R6RNf0XjLGTJEU4FrmxXk
vcpr7eT9jQejS3gnBaVp41uDGYsJ8sfOtJH1dZOBp7A/WAGIUeaIiiCEZ8K6rz+K
NdDbx8+hapCzsW1+Lw+krzQyIswwFs6Of9/OBf1NG0pWaLCm0eTS6hNFTwSDyQbY
gLIgBKrR1DcN92vdhkVJUVy7DXFQWoWRsnRGaX9lb3tdmbPo8YbmWJZw3wtzxvH1
0FzsRol+JBCchMNYVg9mjUSkJcI1mbINgr0LdV79y+b8okkB6gG/zt6hYcVF2xhO
r3nOJZ8L565zqYgO5hFqWSWmYpMDI5c64j4K+3e7PUuzWOBB1nl5YThhGJAg0Md2
vf98ja8Hnf2aV5KjuwJyQkRzfyeXbJKGsiosLExowWjZXGX4CdOLq5H/xIfU+WeX
4+msFJmUgFC0tI0aS1Vz
=fvEj
-----END PGP SIGNATURE-----

--Ehc4EMEa7p1Th0PQu8pK1JTudajJpOUri--
