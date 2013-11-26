Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3KZRAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:00:23 -0500
Received: from sauhun.de ([89.238.76.85]:52227 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304Ab3KZRAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:00:21 -0500
Date: Tue, 26 Nov 2013 18:00:19 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
Message-ID: <20131126170019.GA18696@katana>
References: <1385447520-3306-1-git-send-email-mike.looijmans@topic.nl>
 <20131126090639.GA2568@katana>
 <52946BA6.3080308@topic.nl>
 <20131126122818.GA7427@katana>
 <5294AADC.5070707@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <5294AADC.5070707@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I had looked a bit in that direction, but I think there's currently
> no way for a driver to say "I won't be needing the bus for a while".
> Something like that would be critical for such a pm system to work.

Yes. I wasn't sure if something already existed.

> In any case, it doesn't sound like something I can sell - it's
> understandable for my employer that I spent an extra hour or so to
> clean up and submit the code to upstream, but this appears to go
> into a different class of rework.
>
> So where do you want to go with this? Should I rework the patch to
> make the timeout optional, or should I simply forget about
> integrating at all?

I understand your constraints, yet from a maintenance perspective I
shouldn't have such code in a driver. So, out-of-tree that is for now.

> In fact, on the customer's board, the pca mux is powered by a supply
> so the whole mux can be powered-down too, for which I also needed to
> patch the pca driver to reset its state when the powersupply
> reported that it was going down. I think that particular patch isn't
> of much use to the community though, or is it?

If it uses standard pm callbacks, I'd think this makes sense.

> Most hardware can control power and clocks to the I2C controller,
> which would indeed account for some power savings. But again, that
> would require drivers to provide estimations as to when they will
> need the bus. And it would require much more information on the bus
> controller too, though I suspect that to be the easier part.

There are drivers gating off the clocks simply after every transfer. I
don't know your HW details and workloads, but I wondered if you can
unconditionally switch off the core, do some pinmuxing...

> > Anyway, thanks for letting me know about your requirements (they should
> > have been in the original commit message, though ;))
>=20
> I'm new to Linux kernel development, so please forgive me...

That was just a pointer, no complaint. You did a fine job in supplying
information around your patch, so thanks.


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlNOiAAoJEBQN5MwUoCm21JQQAJJvADh34ywcAJHn1qiN+0PG
UiCuQWOpcRac0l5A52WEK1mgRaSIVkd++fMLKfHC7U73tf8PIcZ2QCx4xdp+In16
fktspUH1wdtZ469mIH5KAOZ1Jj4T0FR5Xt/ucEl8NSMZJajDOpLFRJPbPUPI9eHW
m2T0ThIIajkIBLqsvbiHs3K7Ha4uPkhqMBhmmLnnbBzIH76QyJmfP6pl/AJV8sHQ
q3Rf0d4ZonWQQN0kAc8J+ZfsWVhH/9wCXcK1GNFfYR2/T8kiH4nIdwohwxuFMVrH
5DMFL+n9vdI3NxcOPI2UEP9g1HO5CmBhHwS6mQenxIYH2+vnZHz0ggC/32x+U98b
EyJxekFnrSjdyopMH2XxbtL/UIQlget1HuVWQYZGBNqar4k5EpH3YYuZDr36ixd4
Qrl0KW/UmwxUynkIUmYFRyWJw7+ie1mgDpHvOlgNBr5WgLDzZpvieEcyyqzv0eLm
jAIt29u9UIfCKkV+I+n2VO9F+5A0czxaKu4d8zM7miO0Lv9dH2EptwVr6JcxzZkE
9nkuTrqrx/hOgRuV+14eGbN4owxQvqOGxgxKpvWyXPdmtYtZY/Voi0b+fv/74GN2
qXcLhQGOkicbYLvMIziLoiv6DI6qxahZ/7R/OELvaA4Buop7kGdHncJeNTA/k4dS
F0BSOP+sQaV9yg6OrtR/
=C5kX
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
