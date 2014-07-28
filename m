Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaG1KPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:15:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37859 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752161AbaG1KPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:15:04 -0400
Date: Mon, 28 Jul 2014 12:14:02 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140728101402.GD3952@lukather>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140725131217.GS8181@intel.com>
 <20140725163746.GC20328@lukather>
 <20140725164218.GW8181@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <20140725164218.GW8181@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 10:12:18PM +0530, Vinod Koul wrote:
> On Fri, Jul 25, 2014 at 06:37:46PM +0200, Maxime Ripard wrote:
> > > Can you please send follow patches for these:
> > > - don't recall if I pointed earlier, but can we use direct conversion=
 for
> > >   calculating convert_burst() and convert_buswidth(), latter one at l=
east
> > >   seem doable
> >=20
> > Ok. Do you still want the error reporting for the invalid width and
> > burst size?
> I think for convert_buswidth() we can do away with a switch case and conv=
ert
> the numbers directly

Well, it's already using a switch. Do you want me to remove completely
the function and move the switch where it's used? It's used two times
now, so I'd like to avoid duplicating it.

> > > - don't use devm_request_irq(). You have irq enabled and you have kil=
led
> > >   tasklet. This is too racy. You need to ensure no irqs can be genera=
ted before killing
> > >   tasklets.
> >=20
> > Ok, would calling disable_irq before killing the tasklet an option for
> > you ? that would allow to keep the devm_request_irq.
> disable_irq also does syncronize, so it might work. But then again if the
> probe fails after registering irq due to some other reason, and you get i=
nto
> races with unitialized driver as well.
>=20
> I think it might be easier to amnge by working with plain old request_irq=
()

Yes, devm_free_irq like Russell suggested seems to both address your
concerns, while not having to care about it at probe.

> > I'll also send patches for the various breakages and warnings spotted
> > by the autobuilders.
> Yes please, I havent seen the reports in detail yet, but they are reporti=
ng
> mainly due COMPILE_TEST. DO you really want that?

I don't know, I thought it was the new "default". And it allows to
catch issues like we've seen.

> Yes it did help me to compile for ARM, i didnt see any defconfig which has
> this MACH in arm/configs

I don't know what kernel you were looking at, but it's been introduced
in 3.16.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1iJqAAoJEBx+YmzsjxAgLOQP/Ax5VXAu2NRm3bXWiKtrcSt5
7W7bLozRYhJp+38nHBoOG/Yrt8JU6tCvC307+Kf+QTfRGaRWSgKLsah1ly3RVNNe
KO/vWSQhVKWSQwTMXApJf4LLftzssWpewPTaIW1aSKHtgHyNQYEr5BavNiCL6YBw
BApGKRfgm/mtXAXPZ2ic0dtwl1G/aMWrk9n9ESaeDWkeUAbJHAGOh0eKI24a0czS
FxGNijv3IxtCIKMVI9iTOxaUoqwHAqL7PwSkwjNTMvjhpZHJavYc8dHYYDdoVPqI
7phEdN57MgRgtdeLs82XPvnV5ifK3uqId+Ur9NbYOEzwP4oPZm8o/lx+3zu1tFYw
HLTF4mtRseCSvvXkEg75V+4eZyHKl4SpOY6/Bvwqj7u7lZ2wHI/fCbpVl6iS6yrt
jcTIXrv/ToYa0fKKEWfEStz7qbH/0aqDTGDx3SO0TPflBPD6K1aPXINB5HwwZLEr
kG6pwnV3XisPD3tLI44NaSdgC6vI+3abmqa41y7mCwaVK6FAtZXeFdZJbqVLGBO8
tBg6u/h75FzEO6HH+QxFLbwCKtF/NY6qJD5PW1N6R/dY97rJ+mjyueLALLHZ0NAa
n8MF9pzoXhgO8W+Wr2pJm6fQWu74gsiVuYv/02+dveVwtX++JIJn1ifRJqZWgFSg
MrnY5gB8PY4kHGJtIKp6
=k+DA
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
