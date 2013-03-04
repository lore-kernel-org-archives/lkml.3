Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3CDA6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:58:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3CDA6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:58:31 -0500
Date: Mon, 4 Mar 2013 11:58:21 +1100
From: NeilBrown <neilb@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: use set_bit_le and clear_bit_le
Message-ID: <20130304115821.06bba2f5@notabene.brown>
In-Reply-To: <1362234957-5570-1-git-send-email-akinobu.mita@gmail.com>
References: <1362234957-5570-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FZrWcepgNLey4SAKwd8iDPT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FZrWcepgNLey4SAKwd8iDPT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  2 Mar 2013 23:35:57 +0900 Akinobu Mita <akinobu.mita@gmail.com>
wrote:

> The value returned by test_and_set_bit_le() drivers/md/bitmap.c is not us=
ed.
> So just use set_bit_le(). The same goes for test_and_clear_bit_le().
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> ---
>  drivers/md/bitmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 4fd9d6a..5a2c754 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -846,7 +846,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap=
, sector_t block)
>  	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
>  		set_bit(bit, kaddr);
>  	else
> -		test_and_set_bit_le(bit, kaddr);
> +		set_bit_le(bit, kaddr);
>  	kunmap_atomic(kaddr);
>  	pr_debug("set file bit %lu page %lu\n", bit, page->index);
>  	/* record page number so it gets flushed to disk when unplug occurs */
> @@ -868,7 +868,7 @@ static void bitmap_file_clear_bit(struct bitmap *bitm=
ap, sector_t block)
>  	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
>  		clear_bit(bit, paddr);
>  	else
> -		test_and_clear_bit_le(bit, paddr);
> +		clear_bit_le(bit, paddr);
>  	kunmap_atomic(paddr);
>  	if (!test_page_attr(bitmap, page->index, BITMAP_PAGE_NEEDWRITE)) {
>  		set_page_attr(bitmap, page->index, BITMAP_PAGE_PENDING);

applied, thanks.

NeilBrown

--Sig_/FZrWcepgNLey4SAKwd8iDPT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTPxrTnsnt1WYoG5AQKwoRAAhhyRlsnFZPkRL3Zfkzz3RKbKvfxdZLug
hwa+ICEOygrMy1rbYhB3N/t+bY2MK+WhbBvXGr6B3lBdjN0qA0td7Xd2XSpBU0A0
HMApqXAIrsV4z73iTXoN+t5xij1Do2kCSl0e4FE87YUK9nHOm1HTOW5MBynkj/iJ
4zGiC7OWAbOzrrtqXIFytJUt6U+iesc9CUrzKnf+xKN4yYkxe/9wDUEliLIGMOFs
wvBPhLpEu+h+5//9M8rb53jCQCOxZ9R3JIOmfSJrQHM81/acddwGiKCZyKUmH/wF
OOptR9XxDJvmK6fS0rOcneeIcx7zc+BtRtGYab38KmYEmkfEVx4Vda/I1msfeE7Y
tguYg8+SrZ9whPNxSn1yof8fmXaVt+baBBJ0UYXIZaaF5+QS8hFoXvOiG57JSrgu
We+gq8Tk1dt2LQQjFmZezHJWi64wPLfke8JG07REUGuUyjHTTWg1z9S25IHtOA7J
uAdhX7uZMK95yzZcSdI0iVhRCHvgaa4FS10O7tTvUuK99Ctwwjg3Ee57RZE3oNeW
QkJtC/vfxxI0MQXZFKcfY1AlOGyaEsMxtGK8/nLFkECQcoQPYkzYD6UFgyCFtb68
MHQk1469nuPA+J37eEPGdEJ6ysrzRZZhxAr7/nhauACdijfa+Phg1DQih7vDn6Py
XgMuomRiW84=
=hYfh
-----END PGP SIGNATURE-----

--Sig_/FZrWcepgNLey4SAKwd8iDPT--
