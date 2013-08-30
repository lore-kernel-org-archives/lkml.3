Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3H3HsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:48:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54933 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab3H3HsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:48:10 -0400
Message-ID: <52204E28.3000604@ti.com>
Date: Fri, 30 Aug 2013 10:47:52 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Jones <pjones@redhat.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Release efifb's colormap in efifb_destroy()
References: <CAHkRjk4Ansh+Xr+cPQNacwx=aOb65_hW_MNRx5QVtatJCz5tqg@mail.gmail.com> <1374767291-2874-1-git-send-email-pjones@redhat.com>
In-Reply-To: <1374767291-2874-1-git-send-email-pjones@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jEbQdJPnd2iBBlkqJWKEcPOSxORi3UAT7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jEbQdJPnd2iBBlkqJWKEcPOSxORi3UAT7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25/07/13 18:48, Peter Jones wrote:
> This was found by Alexandra Kossovsky, who noted this traceback from
> kmemleak:
>=20
>> unreferenced object 0xffff880216fcfe00 (size 512):
>>   comm "swapper/0", pid 1, jiffies 4294895429 (age 1415.320s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 aa aa aa aa aa aa aa aa  ................
>>     55 55 55 55 55 55 55 55 ff ff ff ff ff ff ff ff  UUUUUUUU........
>>   backtrace:
>>     [<ffffffff813e415c>] kmemleak_alloc+0x21/0x3e
>>     [<ffffffff8111c17f>]
>>     kmemleak_alloc_recursive.constprop.57+0x16/0x18
>>     [<ffffffff8111e63b>] __kmalloc+0xf9/0x144
>>     [<ffffffff8123d9cf>] fb_alloc_cmap_gfp+0x47/0xe1
>>     [<ffffffff8123da77>] fb_alloc_cmap+0xe/0x10
>>     [<ffffffff81aff40a>] efifb_probe+0x3e9/0x48f
>>     [<ffffffff812c566f>] platform_drv_probe+0x34/0x5e
>>     [<ffffffff812c3e6d>] driver_probe_device+0x98/0x1b4
>>     [<ffffffff812c3fd7>] __driver_attach+0x4e/0x6f
>>     [<ffffffff812c25bf>] bus_for_each_dev+0x57/0x8a
>>     [<ffffffff812c3984>] driver_attach+0x19/0x1b
>>     [<ffffffff812c362b>] bus_add_driver+0xde/0x201
>>     [<ffffffff812c453f>] driver_register+0x8c/0x110
>>     [<ffffffff812c510d>] platform_driver_register+0x41/0x43
>>     [<ffffffff812c5127>] platform_driver_probe+0x18/0x8a
>>     [<ffffffff81aff002>] efifb_init+0x276/0x295
> ---
>  drivers/video/efifb.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 390b61b..1f3eab3 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -289,6 +289,7 @@ static void efifb_destroy(struct fb_info *info)
>  	if (request_mem_succeeded)
>  		release_mem_region(info->apertures->ranges[0].base,
>  				   info->apertures->ranges[0].size);
> +	fb_dealloc_cmap(&info->cmap);
>  	framebuffer_release(info);
>  }
> =20

Thanks, queued for 3.12.

 Tomi




--jEbQdJPnd2iBBlkqJWKEcPOSxORi3UAT7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSIE4oAAoJEPo9qoy8lh71quAP/R/10Id1ARySk2m4B3gV3ico
xHDJZ2dmayMnjNVQgBhuVfReTwGq/xlc2mI3Cxf9Seqxltan5BGOML0Ixf+BRxtZ
BA2CIr/bTmGD2sKc7g5Uyyx+G68n3slv0RQ7kq7739awepQiijYMa4cP+C0iqQqV
ft6qFEjFIWiziAW3Me/kBsYtp7J48C1jLpni8iRQhb7/1qWrWOH6qq4sEkoqaAGK
U2OILzPC/SDJXaTUCgvN4ejsU/T1phdhxT29jtBcCUT1oAeWX7hvCOKSSoePWYJD
jv4dabsg+hueyI/mhb8rFFjc5hvD3N3ekuHXQPG/I+1zfDiAEGVby8sbcappUH77
KO7zMUrRcKSwYblDj9kZcKkg0KAtIHpE8N73F0xreO5YMxeGzYY2VUnY/j+kyhuG
oBUa5x8N7cxbM5LjhGRHbHV6+ONeDQbgyXoXzjT+PpK9irufY3riLUQxusHRiOki
npEvbl38+oTDznhpIyoj21sUjXgAIRrA380hZK3i4SiEOQlLD+KflqIZM40swhqL
0mPrblkUyoIEqWa4PlJsgbaZz944LhEdT9k9kMqCePZ4siRgoj8Ywyem7P9pbicz
qezjxHK3O6s1CouBPctQaJzHQSruRcCtrJdq3pOgeFCNR8ZYE/PmcnlOS1A1Vppz
6fu51sJh++05QSB788KT
=roR3
-----END PGP SIGNATURE-----

--jEbQdJPnd2iBBlkqJWKEcPOSxORi3UAT7--
