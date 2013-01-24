Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3AXXWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:22:50 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48642 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3AXXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:22:41 -0500
Date: Fri, 25 Jan 2013 10:22:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shaohua Li <shli@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20130125102239.18a936de6bc7f696e95ca9f5@canb.auug.org.au>
In-Reply-To: <20130124103040.GB10025@kernel.org>
References: <20130124165448.a27de37fb29ecceac235a7e0@canb.auug.org.au>
	<20130124103040.GB10025@kernel.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__25_Jan_2013_10_22_39_+1100_OhW2Fc57UbNkBLIU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Jan_2013_10_22_39_+1100_OhW2Fc57UbNkBLIU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 24 Jan 2013 18:30:40 +0800 Shaohua Li <shli@kernel.org> wrote:
>
> On Thu, Jan 24, 2013 at 04:54:48PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (sparc32 defconf=
ig)
> > failed like this:
> >=20
> > arch/sparc/mm/init_32.c: In function 'show_mem':
> > arch/sparc/mm/init_32.c:60:23: error: invalid operands to binary << (ha=
ve 'atomic_long_t' and 'int')
> >=20
> > Caused by commit "swap: add per-partition lock for swapfile" from the
> > akpm tree.
> >=20
> > I have reverted that commit for today.
>=20
> can you please apply this:
>=20
>=20
> ---
>  arch/sparc/mm/init_32.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux/arch/sparc/mm/init_32.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/sparc/mm/init_32.c	2012-08-06 16:00:44.133458270 +0800
> +++ linux/arch/sparc/mm/init_32.c	2013-01-24 18:28:23.242077473 +0800
> @@ -57,7 +57,7 @@ void show_mem(unsigned int filter)
>  	printk("Mem-info:\n");
>  	show_free_areas(filter);
>  	printk("Free swap:       %6ldkB\n",
> -	       nr_swap_pages << (PAGE_SHIFT-10));
> +	       get_nr_swap_pages() << (PAGE_SHIFT-10));
>  	printk("%ld pages of RAM\n", totalram_pages);
>  	printk("%ld free pages\n", nr_free_pages());
>  }

Please provide a proper patch to Andrew including a commit message and a
Signed-off-by and Reported-by lines.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__25_Jan_2013_10_22_39_+1100_OhW2Fc57UbNkBLIU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRAcI/AAoJEECxmPOUX5FEwHYQAKCRQZRN0hmbnnW54Nmr0Hv5
vbe6m4RjTDw0kJf0r+w6x5unP/LCD3lYRMPdgykPOg3l8wkIdG1D1FjNsWxjjDiQ
u3z4l1PsYNAaCH8WOxNSml0XWWl6N3rg/gyOKW291hQg15jjxFkL8Ls1QobaaMJs
+J1gszHOJpLu3/l4Zzr6eSadRWtnTTemZ9TI2q09o2XZMtY90BWg+/kQjeUqtLyF
gOG7ZdoDckZ39vmNf0UTG4jXCLEQGmEkfjuMR3x6D09PPH4b5G09R1H1RXGTyngj
udP/gBZLC4wErtpPxg0gHy5i5hWln0Xg7Ez9n827BLnyMWtyZSpcY/FCJKvp734A
70yx43rlIeCwkEmngiZaHDX9XbgH3P9qbUrHhfuJUokM4ruVO5wcXhRRToHH2/ln
168zgUEFUS5L3P84tDIWuPzFC0mPMj74wz56aF7KDz1q9aFGFNeD4c6NBu4lHqYn
p0ruFpIg197xAobfhv2VzCpsvMhXBwv4nfdrJcvoQVPzDwvbKVNHMT7lfuClcaK7
5EdOJCRD4ZPkdIRYlw95LX3puNm3hMApiauudVgr3AImEvidM3Lm1YfY6hdwnYFx
7iwW9w+ICRZsSQPwB3yKXHFp+zIu8dv3lGBLbjI6rPQO7+3OXjjbORje3aaf5/r3
sv+CImGPbWV7r5TD0K3i
=Di3x
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Jan_2013_10_22_39_+1100_OhW2Fc57UbNkBLIU--
