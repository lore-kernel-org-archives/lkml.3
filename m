Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3AKPNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:13:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:50998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3AKPM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:12:59 -0500
Date: Fri, 11 Jan 2013 13:12:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20130111131213.4c1270b1@infradead.org>
In-Reply-To: <20130111113904.251f5fb5587446dbb10694e3@canb.auug.org.au>
References: <20130111113904.251f5fb5587446dbb10694e3@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FjBe7D4ePsBges==yq0nD73"; protocol="application/pgp-signature"
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FjBe7D4ePsBges==yq0nD73
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Em Fri, 11 Jan 2013 11:39:04 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
>=20
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/media/platform/sh_veu.c:1146:22: error: expected '=3D', ',', ';',=
 'asm' or '__attribute__' before 'sh_veu_probe'
> drivers/media/platform/sh_veu.c:1228:22: error: expected '=3D', ',', ';',=
 'asm' or '__attribute__' before 'sh_veu_remove'
> drivers/media/platform/sh_veu.c:1244:2: error: implicit declaration of fu=
nction '__devexit_p' [-Werror=3Dimplicit-function-declaration]
> drivers/media/platform/sh_veu.c:1244:25: error: 'sh_veu_remove' undeclare=
d here (not in a function)
> drivers/media/platform/sh_veu.c: In function 'sh_veu_init':
> drivers/media/platform/sh_veu.c:1253:45: error: 'sh_veu_probe' undeclared=
 (first use in this function)
> drivers/media/platform/sh_veu.c:1253:45: note: each undeclared identifier=
 is reported only once for each function it appears in
> drivers/media/platform/sh_veu.c: At top level:
> drivers/media/platform/sh_veu.c:1095:20: warning: 'sh_veu_bh' defined but=
 not used [-Wunused-function]
> drivers/media/platform/sh_veu.c:1109:20: warning: 'sh_veu_isr' defined bu=
t not used [-Wunused-function]
> drivers/media/platform/sh_veu.c: In function 'sh_veu_init':
> drivers/media/platform/sh_veu.c:1254:1: warning: control reaches end of n=
on-void function [-Wreturn-type]
>=20
> Caused by commit 05efa71bdc0e ("[media] media: add a VEU MEM2MEM format
> conversion and scaling driver") interacting with commit 54b956b90360
> ("Remove __dev* markings from init.h") from the driver-core.current tree.
>=20
> I have applied the following merge fix patch which could be applied
> directly to the v4l-dvb tree (please):

Applied,

Thanks!
Mauro

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 11 Jan 2013 11:35:34 +1100
> Subject: [PATCH] [media] media: remove __dev* annotations
>=20
> CONFIG_HOTPLUG is always true now and the __dev* macros have meen removed.
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/media/platform/sh_veu.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_=
veu.c
> index a018676..cb54c69 100644
> --- a/drivers/media/platform/sh_veu.c
> +++ b/drivers/media/platform/sh_veu.c
> @@ -1143,7 +1143,7 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
> =20
> -static int __devinit sh_veu_probe(struct platform_device *pdev)
> +static int sh_veu_probe(struct platform_device *pdev)
>  {
>  	struct sh_veu_dev *veu;
>  	struct resource *reg_res;
> @@ -1225,7 +1225,7 @@ einitctx:
>  	return ret;
>  }
> =20
> -static int __devexit sh_veu_remove(struct platform_device *pdev)
> +static int sh_veu_remove(struct platform_device *pdev)
>  {
>  	struct v4l2_device *v4l2_dev =3D platform_get_drvdata(pdev);
>  	struct sh_veu_dev *veu =3D container_of(v4l2_dev,
> @@ -1241,7 +1241,7 @@ static int __devexit sh_veu_remove(struct platform_=
device *pdev)
>  }
> =20
>  static struct platform_driver __refdata sh_veu_pdrv =3D {
> -	.remove		=3D __devexit_p(sh_veu_remove),
> +	.remove		=3D sh_veu_remove,
>  	.driver		=3D {
>  		.name	=3D "sh_veu",
>  		.owner	=3D THIS_MODULE,




Cheers,
Mauro

--Sig_/FjBe7D4ePsBges==yq0nD73
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8CvUAAoJEGO08Bl/PELnNvQQALN8Zcs1UYjuKouSvHyavBIS
rn0/XeGbphzj9Ht9EjQsFzO7KvB9ScEaG0+kR8FQY6HxG+vSa4+VtamW2chIxgYX
SPViieZpKZ1p2kJinzpoa+BADEwqKudz72F/LT0rw3eEZInSmgj+BeHsDbqO5kRs
iavdniyv3aGESDnbGIVWj0tm8KYDhT41Bqs/jc7sCKcOs3cdBv90Aktcwup6dNJI
itONgFrpf3SNwvxR1AmSbQ9pNDtDyd2neCpAvm6Aa/vk0HEExWlyA0pLg4OQyelt
8vBp62fU6x2MH5yQPdfRMU26ia9/xd1UsW8fz4HWr09Az7ZgctNFmWMfx1nByMHN
+7kTLgpKSa/1yw43QFdTvbWtTDWvT8zpmFIsnM2qFcSRM4lfwAIgHgKIf0w1QQfY
nMCJfjTGRjlkwtyGuPAlVunqoJpdn9s+tI2WwtTGJj53DuSQmw6az0oIUeIn28BI
LOuuQt6w8zEGeHROm3LDe2zx6YTuX1sQgc2aOb8H0Hafw3VxIiht8QM8BuJW1SgS
k/FLzhhFfBD5vWjbbXgM5pSV+EvBMymxLnFHZQBCqgU2p08hviJSr3Pq/JPqmTDh
JMVCF98HpGJW77hLnO4t5CIT5LNdUHopiTutAzZdpgXh+52JmHLBmHGyziM4tcX4
TfLM6VxedO1C7H+DHhy6
=rV1u
-----END PGP SIGNATURE-----

--Sig_/FjBe7D4ePsBges==yq0nD73--
