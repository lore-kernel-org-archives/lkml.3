Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaKHA2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:28:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56666 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752315AbaKHA2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:28:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: NeilBrown <neilb@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH] Input: gpio_keys: Make sure wake-up buttons work.
Date: Sat, 08 Nov 2014 01:49:06 +0100
Message-ID: <23209922.Rp3elUvURv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141108110058.6c5217e3@notabene.brown>
References: <20141108103707.45bcc7e3@notabene.brown> <20141107234507.GB4439@dtor-ws> <20141108110058.6c5217e3@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4157272.3qoB0WeDaZ"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4157272.3qoB0WeDaZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Saturday, November 08, 2014 11:00:58 AM NeilBrown wrote:
> On Fri, 7 Nov 2014 15:45:07 -0800 Dmitry Torokhov <dmitry.torokhov@gmail.com>
> wrote:
> 
> > Hi Neil,
> > 
> > On Sat, Nov 08, 2014 at 10:37:07AM +1100, NeilBrown wrote:
> > > 
> > > 
> > > If a key is to be used for wake-up, we must not disable
> > > the interrupt during suspend.
> > > 
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > 
> > > diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> > > index 8c98e97f8e41..0b5e54ae343e 100644
> > > --- a/drivers/input/keyboard/gpio_keys.c
> > > +++ b/drivers/input/keyboard/gpio_keys.c
> > > @@ -526,6 +526,8 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
> > >  	 */
> > >  	if (!button->can_disable)
> > >  		irqflags |= IRQF_SHARED;
> > > +	if (button->wakeup)
> > > +		irqflags |= IRQF_NO_SUSPEND;
> > 
> > No, enable_irq_wake() should be enough. I believe Rafael has fixed that
> > in the core, right?
> > 
> 
> Interesting...  you seem to be right, but I was having wakeup problems until
> I added that patch.

This was a fairly recent change made in 3.18-rc1.

> I didn't test exhaustively, but the first time my device entered suspend, the
> gpio-key didn't wake it up.  Subsequent suspends did...
> 
> After I applied this patch, it would reliably wake up even on the first
> suspend.
> 
> So there seems to be something wrong, but maybe it is more subtle.
> 
> Is there a good reason why enable_irq_wake() is only called just as the
> device is being suspended, and why disable_irq_wake() is called on resume?
> To me it would make more sense to just enable it once (if required) and leave
> it enabled....

On some platforms it actually changes the configuration of interrupt
controllers in to a "suspend mode" which is not appropriate for run time
AFAICS.

> I'll see what I can find.

Yes, please.

Rafael

--nextPart4157272.3qoB0WeDaZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUXWiIAAoJEILEb/54YlRxv5oP/2GEP9UtPaA/4esq9m0SiVo6
WlEJCR9ZQDZW4nY5YJjqm0G2mXIKXaSlpdZ8Cu7FsUTBQrNMaeVD1KtD72EiU00u
C5yo18Bj9Lpb8+ajtKy4MaFGXwRsE+Qe1zr2JEAEPelMunHdqv5WDl380Qs0VnEh
JgxIuvCwiGvFrxUUZNWOy3+4SBw0CgrPrURIrYst+GTgrn0M1t6FaBR0kksBvHlw
8xPy5kputzLgkImvN1IxlCFGipTlkCpUxUzz5IpkGbt5znETgf0z11+E/NkjJ2di
CIcHSWciB0LGS9ogTqNJV29m3cp682K9LAQQA18PgGpezbYlgwR336RuUDVm3B7s
ACyn6Mg/v190zCobSosX2vUM5cGczpsfGogQGdxA/RDqVIK9Wbf9kvM9rymNy9Ts
LeOSaNe3V+cC3zNday30/XeQyYoyHwUBMVoomjm7Q+aRVbct+WLaaN5J+e3sCOsg
H4VHWVs7swLi5RbrTHp+V/GSFYxFvzvTdZxUI/lCT6DwNYsO10TnOFPOa90tpqAY
jiL8KlPD3O4ElpM0hPjFZZaVv0nNewVis2CsjMEsZdgBisCQwAp5hJbLC4be5+//
IWcahIkgBYUPVC0mljqZWs+bn8uh0F8CZoygpuksT0xZ9fB1AhOVO7XYBcVrwC4H
cFhEZoJIVXMk2x765o+P
=wYwx
-----END PGP SIGNATURE-----

--nextPart4157272.3qoB0WeDaZ--

