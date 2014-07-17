Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaGQUnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:43:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:34873 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaGQUnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:43:14 -0400
Date: Thu, 17 Jul 2014 22:43:08 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, olof@lixom.net,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, broonie@kernel.org,
        lee.jones@linaro.org, Anton Vorontsov <anton@enomsg.org>,
        javier.martinez@collabora.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v3] charger: tps65090: Allow charger module to be
 used when no irq
Message-ID: <20140717204308.GB13832@earth.universe>
References: <1403300523-17310-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <1403300523-17310-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 20, 2014 at 02:42:03PM -0700, Doug Anderson wrote:
> On the ARM Chromebook tps65090 has two masters: the AP (the main
> processor running linux) and the EC (the embedded controller).  The AP
> is allowed to mess with FETs but the EC is in charge of charge control.
>=20
> The tps65090 interupt line is routed to both the AP and the EC, which
> can cause quite a headache.  Having two people adjusting masks and
> acking interrupts is a recipe for disaster.
>=20
> In the shipping kernel we had a hack to have the AP pay attention to
> the IRQ but not to ack it.  It also wasn't supposed to configure the
> IRQ in any way.  That hack allowed us to detect when the device was
> charging without messing with the EC's state.
>=20
> The current tps65090 infrastructure makes the above difficult, and it
> was a bit of a hack to begin with.  Rather than uglify the driver to
> support it, just extend the driver's existing notion of "no irq" to
> the charger.  This makes the charger code poll every 2 seconds for AC
> detect, which is sufficient.
>=20
> For proper functioning, requires (mfd: tps65090: Don't tell child
> devices we have an IRQ if we don't).  If we don't have that patch
> we'll simply fail to probe on devices without an interrupt (just like
> we did before this patch).

Applied to the dev branch, which I use until I get access to the
official battery.git:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-power-supply.git/com=
mit/?h=3Ddev&id=3D5a3effdc8877132fd12f97fea0d4756614b911c7

-- Sebastian

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTyDVcAAoJENju1/PIO/qaisgP/1+Tej5fVZuEtik1elfp/SxQ
ytPClBtsaVWdn/TE+/1zOjtn5QLHogKAj3R7+Lq+x2Gj013jyUqf4mhetnm0rMio
x1NnJicGn+Dy2lw2YIgbcJbkgWXOXvDPwu+tsMr+T3L/8YJBgK99kWaB9hc68Luu
1TO29Dly5mmmJU2naO0GQEGS6zzLSoULvk2tJJdBQ/p5Omt3u2HFKUm7d1vD3xkE
/1mld1fM1/7q/ahx0FQ6F3b5KZ+39ymKHziraciGinkO/nv548f6XzbJY3/q2Zze
+xTtW9K/C5nVPRm8Cm5J5sJtkfG8SxksM2179NSKOmpiK6s+ESQVaRFIpwJ066D6
tX7md+Mz2EnhYXPStlGSmPdzf0Yw8B3eaeE5MqK++Da4akFOFKCyV4YP/Ko/s+iv
tjfX3B0HOPdRdMsTXDo5GwEDmKCvXIAYy40KUwsDXBWmMPyKn0CUr7LDHmh0vB04
4QGKmpmSNBCBWpzbYeVmgo1SB16HwGdnJW7ovTul79cnQctngdR80HzaieEo6UZB
7jm6My2CzIuMD55OAkOvW3Ug9y8yiiqG3ZgneGqC8rCaYPhro225f+cFgYJ2wy7B
+MqaM5KTGKAPQc9cryjiFSsMjINbo+wOTEIy079ySv7kOgmHSFDrxxHnETqyBcA+
lqGyQB4g18qFrWtKEMHB
=DAxN
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
