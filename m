Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaLDOT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:19:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37031 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaLDOT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:19:28 -0500
Message-ID: <54806D5E.9030501@ti.com>
Date: Thu, 4 Dec 2014 16:19:10 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] video: fbdev-LCDC: Deletion of an unnecessary check
 before the function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5470B315.8000507@users.sourceforge.net>
In-Reply-To: <5470B315.8000507@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="mJBrljmQeWEn4CTEHjwHlnDqCcuh8Icug"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mJBrljmQeWEn4CTEHjwHlnDqCcuh8Icug
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 22/11/14 18:00, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 22 Nov 2014 16:51:31 +0100
>=20
> The vfree() function performs also input parameter validation.
> Thus the test around the call is not needed.
>=20
> This issue was detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/video/fbdev/sh_mobile_lcdcfb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbd=
ev/sh_mobile_lcdcfb.c
> index 2bcc84a..cfde21d 100644
> --- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
> +++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
> @@ -2181,8 +2181,7 @@ sh_mobile_lcdc_channel_fb_cleanup(struct sh_mobil=
e_lcdc_chan *ch)
>  	if (!info || !info->device)
>  		return;
> =20
> -	if (ch->sglist)
> -		vfree(ch->sglist);
> +	vfree(ch->sglist);
> =20
>  	fb_dealloc_cmap(&info->cmap);
>  	framebuffer_release(info);

Thanks, I've applied the fbdev patches. Next time, please use
git-format-patch and git-send-email to send a proper patch series.

 Tomi



--mJBrljmQeWEn4CTEHjwHlnDqCcuh8Icug
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgG1eAAoJEPo9qoy8lh71ixYP/jguEFFPRW4p6hiaH7YF0e5s
LZlX0rudf7ViZelSYCPVBI3p+8B+5YtRWqa+bSpYfdg1pSWZACVX8wCZuASKLm0L
o49jXIx/h71CaMVW0UUdqahfLjRdu36c30cgW99NsBrG1R6ih1VuYtv5egiZPhkY
agDstCZ+IWdVeUQGDRNDTzP+4cF2rdx4U8tndLmMfsPNqAbug9Btrf6rLRXMpE5h
J6fTn5oAZosTDpWnmLtI7K0Kin5/PiqnXB4262r8jwz2yfqJVLUE6KUTdNGb9VKf
f08UqO16CPAoVpl4jzZ3Rm5xORHk8YrFD00MKubGGFo2i2bzYZSUVHaLo2mGrMVX
8v8u9n2UB46fSwhBPeZik88yUg9kZQq5IbywrUZQv0ss8WyWcQheReQ354+o7L0Z
SgWklKC80TTtCimbUyhHqHZoxwiTWX7ZliDme6S7WW04lGZIc8aUT60rQxIrBjrc
UZPIqdz0UbpctzqucZJRE6GEnpR3hb6APNWYAdggXip+xaplU0mh8g4cEYQyHrxa
c8akOhr7u7OTNQGs4nIfhlf7vr59Rk/QUbXM9EH8HRASeo2hCL8e5ZaLdgkK3NLk
SAzSkrBbw7bBZCaX9hnTK9EyExjFr1UCTbtnMq4t8nWSfzD83C4R8ZC61/1SNOvP
st2/YcKuBk5umgFyTw9E
=IWwX
-----END PGP SIGNATURE-----

--mJBrljmQeWEn4CTEHjwHlnDqCcuh8Icug--
