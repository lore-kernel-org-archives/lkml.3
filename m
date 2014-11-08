Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaKIV4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 16:56:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaKIV4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 16:56:13 -0500
Date: Sat, 8 Nov 2014 16:17:08 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH] Input: gpio_keys: Make sure wake-up buttons work.
Message-ID: <20141108161708.0ee85c67@notabene.brown>
In-Reply-To: <23209922.Rp3elUvURv@vostro.rjw.lan>
References: <20141108103707.45bcc7e3@notabene.brown>
	<20141107234507.GB4439@dtor-ws>
	<20141108110058.6c5217e3@notabene.brown>
	<23209922.Rp3elUvURv@vostro.rjw.lan>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+2OfsJ3QLSZRD6P2r04/WWv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+2OfsJ3QLSZRD6P2r04/WWv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 08 Nov 2014 01:49:06 +0100 "Rafael J. Wysocki" <rjw@rjwysocki.net>
wrote:

> On Saturday, November 08, 2014 11:00:58 AM NeilBrown wrote:
> > On Fri, 7 Nov 2014 15:45:07 -0800 Dmitry Torokhov <dmitry.torokhov@gmai=
l.com>
> > wrote:
> >=20
> > > Hi Neil,
> > >=20
> > > On Sat, Nov 08, 2014 at 10:37:07AM +1100, NeilBrown wrote:
> > > >=20
> > > >=20
> > > > If a key is to be used for wake-up, we must not disable
> > > > the interrupt during suspend.
> > > >=20
> > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > >=20
> > > > diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/key=
board/gpio_keys.c
> > > > index 8c98e97f8e41..0b5e54ae343e 100644
> > > > --- a/drivers/input/keyboard/gpio_keys.c
> > > > +++ b/drivers/input/keyboard/gpio_keys.c
> > > > @@ -526,6 +526,8 @@ static int gpio_keys_setup_key(struct platform_=
device *pdev,
> > > >  	 */
> > > >  	if (!button->can_disable)
> > > >  		irqflags |=3D IRQF_SHARED;
> > > > +	if (button->wakeup)
> > > > +		irqflags |=3D IRQF_NO_SUSPEND;
> > >=20
> > > No, enable_irq_wake() should be enough. I believe Rafael has fixed th=
at
> > > in the core, right?
> > >=20
> >=20
> > Interesting...  you seem to be right, but I was having wakeup problems =
until
> > I added that patch.
>=20
> This was a fairly recent change made in 3.18-rc1.
>=20
> > I didn't test exhaustively, but the first time my device entered suspen=
d, the
> > gpio-key didn't wake it up.  Subsequent suspends did...
> >=20
> > After I applied this patch, it would reliably wake up even on the first
> > suspend.
> >=20
> > So there seems to be something wrong, but maybe it is more subtle.
> >=20
> > Is there a good reason why enable_irq_wake() is only called just as the
> > device is being suspended, and why disable_irq_wake() is called on resu=
me?
> > To me it would make more sense to just enable it once (if required) and=
 leave
> > it enabled....
>=20
> On some platforms it actually changes the configuration of interrupt
> controllers in to a "suspend mode" which is not appropriate for run time
> AFAICS.
>=20
> > I'll see what I can find.
>=20
> Yes, please.

Hmmm.. that's frustrating.  I cannot reproduce the problem at all now.  I
wonder what changed..
And I see there are lots of changes in 3.18.

I'll discard my patch and wait to see if the problem recurs.

Thanks for your time,
NeilBrown

--Sig_/+2OfsJ3QLSZRD6P2r04/WWv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF2nVDnsnt1WYoG5AQKVQg//SAo/vc2mS7aTnhoq4ZOHk5UHxPM7vOyi
CukiTdrUUyRTztCOyFppUbqsqCQPvDzb/VUCv/0sm1onvkz25AJw3t0KHY8YqZmn
SZslVQcBLlJLI4cJiuf6m08VZOYkFD61tQ1FD4JgbJmMEqkjdB6mTUKDXS51i5kw
+uBzjD7KWvjr/hJS5ZV/3hU9xray+ldU/dCyyUf+PhDt7Zg4AGqUB58TwYth8SZ1
tN8pOUCgT9/08u+ArJBKv3ZkTj1/lxHYi5G8llK4eI9M95wUPNNY4GiGmP1pRl6z
/+ZKD7MR2YH1WBylvFec60x/GbAlnIyYt71LyDMI4S1JxG7VkauzPvP/lC0cfWQd
SO1ok9SZNPAE78xEMA/7/avsq5Wfn1qqtdKcN1j4OMyPhvK1MiWM3IuEyh8IHdOM
gkZFAprNzFL1Dor5OhnQaCXiQTJaqvxMpXo91OwJSpjaARSGSnVevc8vhchNLkx1
ABtsn6cghwRlgzzpYpHUEG86FH/vRaiUGrvY8UXjJkeVzqWxAU5PhuKgbACM5BUF
V6V7owNqtX02u4WQ9/9fZB3Ert2IBVQPeWl6qDp9sWlnjACXydTi+FfJi6R2PEwR
Di+wNlysFW1TuGarb/1d8TIOIlwvGWpnS4PopTvivYDokX9Oo9VY+dLUCYwh0+5L
HrFfwZMm8ew=
=OuhB
-----END PGP SIGNATURE-----

--Sig_/+2OfsJ3QLSZRD6P2r04/WWv--
