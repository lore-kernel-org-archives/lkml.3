Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaIZMFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:05:55 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51217 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaIZMFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:05:53 -0400
Date: Fri, 26 Sep 2014 14:05:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Mikko Perttunen <cyndis@kapsi.fi>, edubezval@gmail.com,
        swarren@wwwdotorg.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, juha-matti.tilli@iki.fi
Subject: Re: [PATCH v6 0/4] Tegra124 soctherm driver
Message-ID: <20140926120547.GB26591@ulmo>
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
 <20140926101918.GM31106@ulmo>
 <54253E7C.9080704@kapsi.fi>
 <20140926114852.GO31106@ulmo>
 <5425554B.7060102@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <5425554B.7060102@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 03:00:11PM +0300, Mikko Perttunen wrote:
> On 09/26/2014 02:48 PM, Thierry Reding wrote:
> >On Fri, Sep 26, 2014 at 01:22:52PM +0300, Mikko Perttunen wrote:
> >>On 09/26/2014 01:19 PM, Thierry Reding wrote:
> >>>On Fri, Sep 26, 2014 at 12:43:09PM +0300, Mikko Perttunen wrote:
> >>>>Hi,
> >>>>
> >>>>this series adds support for the thermal monitoring features of the
> >>>>soctherm unit on the Tegra124 SoC.
> >>>>
> >>>>The branch is also available in my github repo,
> >>>>   git://github.com/cyndis/linux.git soctherm-v6
> >>>>
> >>>>Thanks,
> >>>>Mikko
> >>>>
> >>>>Mikko Perttunen (4):
> >>>>   of: Add bindings for nvidia,tegra124-soctherm
> >>>>   ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
> >>>>   ARM: tegra: Add thermal trip points for Jetson TK1
> >>>>   thermal: Add Tegra SOCTHERM thermal management driver
> >>>>
> >>>>  .../devicetree/bindings/thermal/tegra-soctherm.txt |  53 +++
> >>>>  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  44 ++
> >>>>  arch/arm/boot/dts/tegra124.dtsi                    |  47 ++
> >>>>  drivers/thermal/Kconfig                            |  10 +
> >>>>  drivers/thermal/Makefile                           |   1 +
> >>>>  drivers/thermal/tegra_soctherm.c                   | 471 ++++++++++=
+++++++++++
> >>>>  include/dt-bindings/thermal/tegra124-soctherm.h    |  13 +
> >>>>  7 files changed, 639 insertions(+)
> >>>>  create mode 100644 Documentation/devicetree/bindings/thermal/tegra-=
soctherm.txt
> >>>>  create mode 100644 drivers/thermal/tegra_soctherm.c
> >>>>  create mode 100644 include/dt-bindings/thermal/tegra124-soctherm.h
> >>>
> >>>One thing that I've wanted to start doing for a while now is request
> >>>patch submissions like this to come accompanied with a way on how to
> >>>test them. Ideally this would be in a scripted way that can test for
> >>>success programatically, but it doesn't necessarily have to be if it
> >>>turns out too difficult or impractical to do.
> >>
> >>Indeed, that would be very useful.
> >>
> >>>
> >>>The goal is to eventually come up with a test suite that can run the
> >>>majority of test cases automatically to make it easy to test for any
> >>>regressions. And even if tests can't be run automatically it'd still
> >>>be an advantage to have them all collected in some repository, since
> >>>it saves a lot of typing and time to run tests, and it will give us
> >>>a standard set of tests that everybody can verify changes against.
> >>>
> >>>I realize that it's somewhat unfair to start requesting this from you
> >>>now, but we've got to start somewhere. Could you give a short summary
> >>>of how you test this? What are the interfaces that the kernel exposes
> >>>for these thermal drivers?
> >>
> >>You need to enable the driver in Device Drivers -> Generic Thermal sysfs
> >>driver -> Tegra SOCTHERM thermal management. Then, you should see
> >>directories appear in /sys/class/thermal. You can also use the `tmon' t=
ool
> >>included in the kernel tree to quickly see values; that's what I use for
> >>testing.
> >
> >Okay. So what are expected values for these temperatures? It's going to
> >be pretty much impossible to say what the correct value is on a given
> >board at any time, but perhaps a "test" could consist of checking that
> >all temperatures are within a reasonable range.
>=20
> On Jetson TK1, at least without the CL-DVFS series, I get around 32 Celsi=
us.
> If you want to account for cpu/gpufreq then I guess something like 25-70
> would be a good range.

Okay, thanks. Can you remind me how this relates to the thermal tripping
support?

Thierry

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJVabAAoJEN0jrNd/PrOh+OkP/jb9pNsw0MYPpIidVnFyjoV8
MpGEn+DtGUoKp/oe1beSssTQh+HDEFPYAH3tiY40nXGjRHUGoZcRztzKSxmwJfE3
yJjKQC9GyJ8Y8wMQaoGNAm4dAi5EJqrKXp6j/kgui2ulXrdFh1Km+kuljcuydY/I
CRx5MYUu7HgigE2donK49UI8IPOz/53AN6QqTeyZRA16/5bWdnwGqie1J51+Gyrp
HY1UsQ5PG5prHo6hw5wRx3iuFtH3Zq/ePgat6aL6gUcVCHvKxrS/jfC9RrjzM9FL
G0Z8kt9QdgZ75P3JNxeWFwfdT4kOm7/RxsT2anakO0mR/KMbi9dFIX5WYETDOeHi
FznyqTvFXU+v9su4DvRvHSFBf3Zj5cJ08K9AHRemjzD/S/nzFqEYSw3ddDhQBDh2
uAZOnmZJ8HZ6JjVQ0CCUark6XGNkvhIAS9yKyd+S7+ejqYH7eobUwb3k+txOKHNA
AmOp4ALlw+881beqSEm1eX0YDDWMyAGpfBEFsftFNirE+nX2BpE2T+MBDuIEP1jC
gNHE0+eGBDNx3ayNiYf2vJ4cUrjGGl/4FZj80MePAY+5ccXmkEdPew2j/Y73en3G
m9lb7/61pJX4qrQjU3UYvY1+mv61lbrbKxy9QJ9iWdjPLqXqkci55QtcJJA+sI5q
UISSJ2HNIQ1NEeLB9u0C
=dh37
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
