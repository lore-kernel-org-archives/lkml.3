Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaEGInd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:43:33 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49221 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaEGInb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:43:31 -0400
Date: Wed, 7 May 2014 10:41:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [linux-next] pwm: lpss: fix const qualifier discard
 warning
Message-ID: <20140507084137.GD6362@ulmo>
References: <1399044179-17912-1-git-send-email-mq@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
In-Reply-To: <1399044179-17912-1-git-send-email-mq@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 05:22:59PM +0200, Jan Moskyto Matejka wrote:
> Fixing this warning:
> drivers/pwm/pwm-lpss.c: In function =E2=80=98pwm_lpss_probe_pci=E2=80=99:
> drivers/pwm/pwm-lpss.c:192:2: warning: passing argument 3 of =E2=80=98pwm=
_lpss_probe=E2=80=99 discards =E2=80=98const=E2=80=99 qualifier from pointe=
r target type [enabled by default]
>   lpwm =3D pwm_lpss_probe(&pdev->dev, &pdev->resource[0], info);
>   ^
> drivers/pwm/pwm-lpss.c:130:30: note: expected =E2=80=98struct pwm_lpss_bo=
ardinfo *=E2=80=99 but argument is of type =E2=80=98const struct pwm_lpss_b=
oardinfo *=E2=80=99
>  static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
>=20
> That warning was introduced in commit 093e00bb3f82f3c67e2d1682e316fc012bc=
d0d92
> ("pwm: lpss: Add support for PCI devices").
>=20
> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
> ---
>  drivers/pwm/pwm-lpss.c | 1 +
>  1 file changed, 1 insertion(+)

This was reported over a week ago by the kbuild test robot and I've had
fixes for this (and an additional sparse warning) in my tree for a while
now. Interestingly everybody at Intel seems to have forgotten about this
driver after their patches got merged since nobody cared to respond.

I've now pushed out the patch that I had locally.

Thanks,
Thierry

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTafHBAAoJEN0jrNd/PrOhcUYP/iU0bcIspFvzwW5Fa5D6buDx
9IGZ9mbFeubNwP/bqOLd59JAc9JZqu73WX9CCtV30B7imEmzba7yBOOYP7DYEwkZ
eh0pJlTPj5Z/KX3p9wLNFY2eJQ302fSCzj0IkI5qrhaWE0XeYJvZ0P8MnbgL5f7J
oRH66bvKnQZQMj89p0dSwZy9MhlTb0BhR9eUgMUmPB88MA6hq0QE/FjrhOBui/15
waIHRMLq2XpBtFIJObVRGJDBp6KXpcXMHWbcYEVDaWUtJnyu5mb51WepNac0odmT
VMZazLfCx3OGSvn65f3oXFwr3Ekae8YfEXVuqKchBxB/vMVHnntlyAglmKpa2hFK
oWbyauTqlrVYDouYnYq9vuKSoDswGB30GDRh9FfUQI6re7E5K0Nb/csLLLLM26YZ
kQtnbNZDbP+9h4qewTrpNps14VLBhkqdKIpW9VzTTjph0s+EF3P0OpqoVAKtdhM4
wDIzhowYoENVRUzZY0oVTxI1F+Ck4lUYQE+sZ8hcTvW3X3C6ZIJf3/r4eTpIm0jc
UVVfEcoti8kf7nuzFdVT+Lglfnc86cZFDzdKu5L4KvmusiBqVcfzgaE162lA1fhG
yPB4jyoIUSv70adabMCmseRi/M3UoDhwuR21VNT3JV7M2jgodJkH+zj3f3CeUw6h
RUmTjPWvHjaFmU5NtbG3
=C82G
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
