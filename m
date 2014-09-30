Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaI3Klp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:41:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35400 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaI3Klm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:41:42 -0400
Message-ID: <542A88DE.6080301@ti.com>
Date: Tue, 30 Sep 2014 13:41:34 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] framebuffer: fix screen corruption when copying
References: <alpine.LRH.2.02.1409161236550.3150@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1409161236550.3150@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="q09BGuI7AAmfIaFncEcDWRQ8Ior3A6W1v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--q09BGuI7AAmfIaFncEcDWRQ8Ior3A6W1v
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 16/09/14 19:38, Mikulas Patocka wrote:
> The function bitcpy_rev has a bug that may result in screen corruption.=

> The bug happens under these conditions:
> * the end of the destination area of a copy operation is aligned on a l=
ong
>   word boundary
> * the end of the source area is not aligned on a long word boundary
> * we are copying more than one long word
>=20
> In this case, the variable shift is non-zero and the variable first is
> zero. The statements FB_WRITEL(comp(d0, FB_READL(dst), first), dst) rea=
ds
> the last long word of the destination and writes it back unchanged
> (because first is zero). Correctly, we should write the variable d0 to =
the
> last word of the destination in this case.
>=20
> This patch fixes the bug by introducing and extra test if first is zero=
=2E
>=20
> The patch also removes the references to fb_memmove in the code that is=

> commented out because fb_memmove was removed from framebuffer subsystem=
=2E

Thanks, queued for 3.18.

 Tomi



--q09BGuI7AAmfIaFncEcDWRQ8Ior3A6W1v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKojeAAoJEPo9qoy8lh71lXMP/RTdWCb+w77kj6x/P+xap8Mx
lM+OD2Go1/5Ye4UlVXIJdfQOL4c6ukTyLcLqtJTQaccgqvzjsf8opEqYLU4PgiMs
Qx31XEHJfW9fo1XUWJefAKARmAhYzuB62Q5tKToJ9/3sVX+ETDwxHaW4VmRuE0ZP
l04RjAKu7FBpqUWL1R/UIfQZmlUp8WPk5ncYevfx2FFXGBq0sNb8GjZtSurGeWSB
TzRDoBn6MUQKpbEQ11el5zRhc5cdhzBcd3SXQHSGF4rtCpE85rN3+GJ+2/oTZfg1
PcGUE4LMry/T7jpV9+BLnWylrfQ9eQAGtrSKEYBOQ61QqWvn9/YQSG+R4Xe+JGzP
mbpzZ5fMZW7F+ixCfUsAQm8Ybr+eZYfdRaEIInkJyOWhVzSfo5/xyxHsU31IzqEL
E0pEPw1cBV9NA8H8rMNdPAueMTyUDMUIglPtvsoQmeBFIFd6p8GHjVya4447/O0m
HJ15shs946MVx1Wxd4lFsCplD3Pn7xkzvwOuXqzJET8P0ZLgfYAJI9uQhQQVyzrf
mIh4I6CxqYKI6dYSzTFFMWcYXGQ0y/Ww+qZB57CETMJXIqGbWz4USN85Jelwuc0O
vdlmsI7GGzOKN5dgVPWJ6VOOaTLSBOiOuJLgrHbnMvbGqwdDY8mmVLt4UVju3OpX
wu5LbGrsbuawLYjZiCVt
=44MG
-----END PGP SIGNATURE-----

--q09BGuI7AAmfIaFncEcDWRQ8Ior3A6W1v--
