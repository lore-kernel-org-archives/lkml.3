Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaKGIRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:17:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40399 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaKGIRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:17:21 -0500
Message-ID: <545C7FED.2000603@ti.com>
Date: Fri, 7 Nov 2014 10:16:45 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>
CC: <hpa@zytor.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <stefan.bader@canonical.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <ville.syrjala@linux.intel.com>,
        <david.vrabel@citrix.com>, <jbeulich@suse.com>, <toshi.kani@hp.com>,
        <plagnioj@jcrosoft.com>, <bhelgaas@google.com>
Subject: Re: [PATCH V6 03/18] x86: Use new cache mode type in drivers/video/fbdev/gbefb.c
References: <1415019724-4317-1-git-send-email-jgross@suse.com> <1415019724-4317-4-git-send-email-jgross@suse.com>
In-Reply-To: <1415019724-4317-4-git-send-email-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="vsnfs2fmdA24VkTavR0IxXnQcai39ueTb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vsnfs2fmdA24VkTavR0IxXnQcai39ueTb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/11/14 15:01, Juergen Gross wrote:
> Instead of directly using the cache mode bits in the pte switch to
> using the cache mode type.
>=20
> Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/video/fbdev/gbefb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/gbefb.c b/drivers/video/fbdev/gbefb.c
> index 4aa56ba..6d9ef39 100644
> --- a/drivers/video/fbdev/gbefb.c
> +++ b/drivers/video/fbdev/gbefb.c
> @@ -54,7 +54,8 @@ struct gbefb_par {
>  #endif
>  #endif
>  #ifdef CONFIG_X86
> -#define pgprot_fb(_prot) ((_prot) | _PAGE_PCD)
> +#define pgprot_fb(_prot) (((_prot) & ~_PAGE_CACHE_MASK) |	\
> +			  cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS))
>  #endif
> =20
>  /*
>=20

For this and vermilion fb:

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--vsnfs2fmdA24VkTavR0IxXnQcai39ueTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXH/tAAoJEPo9qoy8lh71C00P/RaafIIgv9NRIVBW1APfzn6C
3dpdWIgoG0gJAAc6XfDYjKd/+WtNSEPK62WALB82FjP/W4z8xoAPEHXN8HKhhM11
PUGrnNRNqakaC7b0fmJRWWdvM4BYBD/r5es4PCHEVUeuUkJo0GEeBwaJBIUh62Qj
CBL2LAjDwSv0YCWaRQNKCPnkDVMOxGirZMY6tIIL+jsEQ6T+VTATodQwHxXN5jau
qT04+wHEEwN1/sQ9yLqDwW1lv1ja96hZgDpKDZnaJvdbRsDX5CZjKC3sRsx2M/iM
Rd6ZGOPPmCTtcGUo1pNTtgwooKLI7n4iQ+m+psma4lgfvjrU4MgUPM2bGsdb0Gb8
vo77EOIadWAPwiB6mLKiFd+52jZMEmA5lfsYQqE/+MuiZGkR5riM9M/pTfkI+8hB
4al4yYhC2bUe0wjzdMB4BNsJ1PcC/HAqq840tE1H4RTxll+uo423Xwy9EnwHRYtU
8Z9xuc0kWnm94CGUEc4BYxB4te8HbFHwOzbRHOS4RDdZZERY8yIjnvInrPSjJGaJ
DJN3/h0uVBMMpNdPREcnJcdLlxRvav1YEH60uckGDeIM1YS7e7P+GWLlk3isBWHP
vngArvlNt0XdAL39lDYJm2u5DXtIrqXxFRaxvf73OdMW68esgM+OscMzP5CNPeSU
q/wqrTHW0AL2adUHgvdr
=pT/u
-----END PGP SIGNATURE-----

--vsnfs2fmdA24VkTavR0IxXnQcai39ueTb--
