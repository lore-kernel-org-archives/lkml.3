Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaG1JpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:45:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37738 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750981AbaG1JpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:45:03 -0400
Date: Mon, 28 Jul 2014 11:41:48 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        zhuzhenhua@allwinnertech.com, dmaengine@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140728094148.GC3952@lukather>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140725131217.GS8181@intel.com>
 <20140725163746.GC20328@lukather>
 <20140725164518.GQ21766@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <20140725164518.GQ21766@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Fri, Jul 25, 2014 at 05:45:19PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 25, 2014 at 06:37:46PM +0200, Maxime Ripard wrote:
> > Hi Vinod,
> >=20
> > On Fri, Jul 25, 2014 at 06:42:17PM +0530, Vinod Koul wrote:
> > > - don't use devm_request_irq(). You have irq enabled and you have kil=
led
> > >   tasklet. This is too racy. You need to ensure no irqs can be genera=
ted before killing
> > >   tasklets.
> >=20
> > Ok, would calling disable_irq before killing the tasklet an option for
> > you ? that would allow to keep the devm_request_irq.
>=20
> That's not really an acceptable approach if you can use shared
> interrupts.

We don't, but yes, I see your point.

> A better alternative would be devm_free_irq() to give a definite point
> that the interrupt is unregistered in the driver remove sequence.  That
> allows you to keep the advantage of devm_request_irq() to clean up during
> the initialisation side.

Ah, right, thanks.

> An alternative approach would be to ensure that the hardware is quiesced,
> and interrupts are disabled.  Then call synchronize_irq() on it, and at
> that point, you should be certain that your interrupt handler should not
> process any further interrupts for your device (though, in a shared
> interrupt environment, it would still be called should a different device
> on the shared line raise its interrupt.)

Actually, unless I'm missing something, that's pretty much what we're
doing here.

I disable all interrupts in the DMA controller, I call
synchronize_irq, and then kill the tasklet. The only interrupts I
could get are spurious, and we made sure such kind of interrupts
couldn't schedule the tasklet either.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1hrcAAoJEBx+YmzsjxAghQIQAJYXjX2BMDQMrqf8id87sd06
netbgOfb0c5vvS1gv107So90LFAQn2wLVv79c4ggcYEK1UcbVCHGa7eAsnKFpal3
r8QCF9Koie5pr7Ds33gGTueS/v+Jx61hs51ARVfhl8DkjQd6qtIYVqNu0NEt5Uds
DjYDsIGz7jxk/XYOx6sl9Ae8HOeehDVSdKzMcRtUjSy5IOMtivsJ3mN96z/e831h
Q6d41Y8lW8IZKyu3hsG2zme8BQF8d/thRRERMPHKAxaOY96vC4/OwIin1JCXaFXj
r1jSMTJe6RkCik9szYiBw5urSMD+EZjxiq9BTClVdJrNHqUctGdptgNJHHo69CdE
hPHshGW3FxU80UISELn1AlqWHK/8qmyrYjLtWxJLY0wP4owcuemByFIEFJI0njqL
fdZixMbmdYjFH3yetUqZ3lqowxiO0bccZi5UbYgXIhCuXhE97+RYemsNG8gFBnfB
J7S107Amuu04XGTEGT4EkU3lg7pvVlwHGI1Jh2zwPsmL5IA/TEoRCwLO7lW+JD1o
vQ6vipJ6zZ5z0qQR+89IpC0cNg8xFZb4f6tSdMgcT9ifn09RXab5H37HwjTRMsYy
dX+nDFUrphnaiFa3XLAqSGGfQkedb4YPCnKY/c6jjfBkuUiIsWBMauPhnyG4G7Su
QZjdH1YTcrjzXOsTMOat
=bvKc
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
