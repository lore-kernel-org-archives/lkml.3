Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaHUNQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:16:17 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62219 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaHUNQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:16:14 -0400
Date: Thu, 21 Aug 2014 15:16:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20140821131552.GA19293@ulmo.nvidia.com>
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140821081619.GZ2452@ldesroches-Latitude-E6320>
 <20140821103706.2349915d@bbrezillon>
 <20140821090406.GA13733@ulmo>
 <20140821114159.319e741b@bbrezillon>
 <20140821095202.GA21848@ulmo>
 <20140821150600.37788d82@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20140821150600.37788d82@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 03:06:00PM +0200, Boris BREZILLON wrote:
> On Thu, 21 Aug 2014 11:52:03 +0200
> Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Thu, Aug 21, 2014 at 11:41:59AM +0200, Boris BREZILLON wrote:
> > > On Thu, 21 Aug 2014 11:04:07 +0200
> > > Thierry Reding <thierry.reding@gmail.com> wrote:
> > >=20
> > > > On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
> > > > > Hi Ludovic,
> > > > >=20
> > > > > On Thu, 21 Aug 2014 10:16:19 +0200
> > > > > Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> > > > >=20
> > > > > > Hi Boris,
> > > > > >=20
> > > > > > You can add
> > > > > >=20
> > > > > > Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> > > > >=20
> > > > > Thanks for testing this driver.
> > > > >=20
> > > > > >=20
> > > > > > Only one issue but not related to your patches, you can't displ=
ay
> > > > > > quickly the bootup logo since the panel detection takes too much
> > > > > > time.
> > > > >=20
> > > > > Yes, actually this is related to the device probe order: the
> > > > > hlcdc-display-controller device is probed before the simple-panel=
, thus
> > > > > nothing is detected on the RGB connector (I use of_drm_find_panel=
 to
> > > > > check for panel availability) when the display controller is
> > > > > instantiated. I rely on the default polling infrastructure provid=
ed by
> > > > > the DRM/KMS framework which polls for a new connector every 10s, =
and
> > > > > this is far more than you kernel boot time.
> > > > >=20
> > > > > Do anyone see a solution to reduce this delay (without changing t=
he
> > > > > polling interval). I thought we could add a notifier infrastructu=
re to
> > > > > the DRM panel framework, but I'm not sure this is how you want th=
ings
> > > > > done...
> > > >=20
> > > > Other drivers return -EPROBE_DEFER when a panel hasn't been registe=
red
> > > > yet. This will automatically take care of ordering things in a way =
that
> > > > DRM/KMS will only be initialized after the panel has been probed.
> > >=20
> > > Actually I'd like to avoid doing this with a deferred probe, because,
> > > AFAIU, the remote endpoint is not tightly linked with the display
> > > controller driver (I mean the display controller can still be
> > > initialized without having a display connected on it).
> > > Moreover the atmel dev kit I'm using has an HDMI bridge connected on
> > > the same RGB connector and I'd like to use it in a near future.
> > > Returning -EPROBE_DEFER in case of several devices connected on the
> > > same connector implies that I'll have to wait for all the remote
> > > end-points to be available before my display controller could be
> > > instantiated.
> > >=20
> > > While this could be acceptable when all drivers are statically linked
> > > in the kernel, it might be problematic when you're using modules,
> > > meaning that you won't be able to display anything on your LCD panel
> > > until your HDMI bridge module has been loaded.
> >=20
> > No. HDMI should be using proper hotplugging anyway, hence it should be
> > always be loaded anyway. You're in for a world of pain if you think you
> > can run DRM with a driver that's composed of separate kernel modules.
>=20
> I was talking about the external RGB to HDMI encoder, should the driver
> for this encoder (which is not on On Chip block) be compiled
> statically too ?
>=20
> >=20
> > Also if you don't want to use deferred probe, then you're in for the
> > full hotplugging panel dance and that implies that you need to fix a
> > bunch of things in DRM (one being the framebuffer console instantiation
> > that I referred to in the other thread).
>=20
> For now, I wait until there is a device connected on the RGB connector
> (connector status set to connector_status_connected) before creating an
> fbdev. It might not be the cleanest way to solve this issue, but it
> works :-).

Yeah, I guess that's one way to do it. But it's tricky to get right when
you have several outputs. Which one should be considered the primary and
trigger fbdev creation?

> > You also can't be using the
> > current device tree bindings because they all assume a dependency from
> > the display controller/output to the panel. For hotplugging you'd need
> > the dependency the other way around (the panel needs to refer to the
> > output by phandle).
>=20
> Here [1] is a proposal for notification support in the drm_panel
> infrastructure (which is not that complicated), and here [2] is how
> I use it in my atmel-hlcdc driver to generate hotplug events.
>=20
> Let me know if you want me to submit a proper patch series...
>=20
> Best Regards,
>=20
> Boris
>=20
> [1]http://code.bulix.org/scq4g3-86804
> [2]http://code.bulix.org/7dg501-86805

Those look interesting. Any chance you could look into how to do the
same without resorting to notifiers?

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9fEIAAoJEN0jrNd/PrOhgGoP/0VcZa+s3shZQ1wXu8H2Kf2u
UoBRVTeRNypZ2e0HsMbNOv+qZsQDZ23DIOhcGtMnbSZWc84tTPkuCDk5MhO1RTn5
d0d+4b6JEVNLvLXY6emif9YbGd6un+SC6ZJ8bpkVKuEihD3q7qalNi2bt/j9ZdAB
sQSOR1QGfnfZ2hOlHhl83C5WXIEB5sMpNHHWfrCss9MgJcvhhIC+tZzio+0FRFs/
7Czl3qdvSG5AKNWmFQNg0dD2Qf16xYlxpSbmcF+W/yaM4O6pTJSbgbiemeBuMrVS
O+fL79BRwxMmwpXK4YDHC2sWxjlRtmsdzOjjm6rAmSjWsbNOxMW0dbOULDVj5ZkA
7BtfDzpHNAPS2sZYbyq0rdEagfwEtYXj/Ey9n/cjYmt+QEhoYTLG2AAraFEC28N3
KPOSsSF3J5zEOisFMkJRLfX7acOmRBpMIX2cVSBolX9tH+CkRij5aTJKYk5J40aa
XkilcaMDlLgOx6+fznLG4oD0XgVbTJWOXrkkvok2FEiiEjbeCX9w1PVtkqMuNFvx
+LgEhVs+ryKl+75k1SOE5RgUjwUmVVuEpA54/1HECsZL2IEAJmxbbhKXhVyIzByZ
auK17GNQ+39ANKWEyUnOubat59kCYP8LsJ8oE1uVb2DfOiREzhwVNg8iFOfnG0uP
TPsssKQWh8LreW88d0ZD
=E0mK
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
