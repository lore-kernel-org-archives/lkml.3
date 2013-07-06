Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3GFILB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 04:11:01 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53929 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3GFIK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 04:10:58 -0400
Date: Sat, 6 Jul 2013 10:10:45 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCHv4 08/10] clocksource: sun4i: Remove TIMER_SCAL variable
Message-ID: <20130706081045.GY2959@lukather>
References: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
 <1373062725-19625-9-git-send-email-maxime.ripard@free-electrons.com>
 <alpine.DEB.2.02.1307060031030.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9v2bTOXBzuB5Piju"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307060031030.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9v2bTOXBzuB5Piju
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 06, 2013 at 01:17:41AM +0200, Thomas Gleixner wrote:
> I really recommend that you go out for lots of beer/wine NOW and
> resume reading this mail when you recovered from that.
>=20
> I definitely appreciate your responsivness to feedback, but please go
> back and read my reply to the previous version of this patch
> carefully. You might eventually find out that I pointed you to another
> redundant clk_get_rate() call in that code.
>=20
> After you did this, please go through the other patches in that series
> and check how many new instances of clk_get_rate() calls you add down
> the road. I did not even bother to look whether you cleaned it up
> between v3 and v4, but I'm quite sure you did not. If I'm wrong, I owe
> you a beer at the next conference.

Wow, you really want me to drink, do you? :)

Actually, I did clean up. The other user you spotted that was previously
introduced in the patch 4/10, and if you take a look at it, you'll see
that it actually uses the rate variable like you suggested.

Now, your mail made me realize that patch 10 introduced a direct
clk_get_rate call, that I forgot to cleanup. After applying these
patches, it's the only user left.

I'll send a v5. Do you have any additionnal comments on those patches to
avoid wasting more electrons?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--9v2bTOXBzuB5Piju
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR19EFAAoJEBx+YmzsjxAg+HQP/RTvurv1wYAYW9t6OpEkzOhN
0c0+E1EyGD1kcpsJulNxloKSbYDkM1PV8Kcn7QnWiJvQmjUBs5BeU5WxgUKMygVN
xuQgvzkJ/mWIsEp1Yk+HQHOX9sCfgGFE8AXX/UivYcfv2oGn2TqDLcczYHrFOUBl
ZchSfLcBjrkxS3+k094kQ7mHHUA4YyuDnnwYcifRCh2I7IHvDXSYdyZs2bD33P6t
bjTUbOPbJ++oixX2PtYTGk83FGU50rraGA5J83c6kroY+QnXFXX/i4Z0jkXA9nQb
r9E/PLPGWPFhOatb+eNMQ70rOZViCnR1x6FHZGQz9tBgf3BVsxxlCCUJ/APJgwps
3Su6c0aHjZ1BluJTRLuExPZWkcaiR+s6ZfM6Zrl4FOpYREAcuTDSIhafGnMjAodg
vTVnrRjYWEOTuENOPmg4mRA+OQJmX1abJwahQbUg7yW3ze8pK7zYXTKKvCfA0xt1
FZxYTGpTr7US6HOGmtggJ6cXf0By3aXBkmTNiZZz81E1rfpivHnDWe/UrqeFfQqs
kDwgcOUslUSAbrOB2eaVSoYGp7cJPN+pTqfmi/EJA0PZbS3NVbBL9LdxRyl/jb4Z
FJP73rHlepjAE2j35RgZfKhjtWxqgCLKf8+0rfsyUKPn8NomxaxXlGtvO0fJk3mP
nIn/awU5kGn0BdQy5ZzK
=WPDA
-----END PGP SIGNATURE-----

--9v2bTOXBzuB5Piju--
