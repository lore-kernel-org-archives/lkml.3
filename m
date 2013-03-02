Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3CBPkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 10:40:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56119 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3CBPkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 10:40:16 -0500
Date: Sun, 3 Mar 2013 02:39:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Message-Id: <20130303023959.958e3b2ba3bace59ca01e956@canb.auug.org.au>
In-Reply-To: <20130205183007.GA5652@konrad-lan.dumpdata.com>
References: <20130204151456.ea053895a487a19013e4991f@canb.auug.org.au>
	<20130205183007.GA5652@konrad-lan.dumpdata.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__3_Mar_2013_02_39_59_+1100_=qmIkPVWX/ECjZqz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__3_Mar_2013_02_39_59_+1100_=qmIkPVWX/ECjZqz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Tue, 5 Feb 2013 13:30:08 -0500 Konrad Rzeszutek Wilk <konrad.wilk@oracle=
.com> wrote:
>
> On Mon, Feb 04, 2013 at 03:14:56PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the xen-two tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > arch/x86/xen/mmu.c: In function 'xen_init_mmu_ops':
> > arch/x86/xen/mmu.c:2213:10: error: 'struct x86_init_ops' has no member =
named 'mapping'
> > arch/x86/xen/mmu.c:2213:39: error: 'xen_mapping_pagetable_reserve' unde=
clared (first use in this function)
> >=20
> > Caused by commit 8154d7a6b9b9 ("xen/pvh: Implement MMU changes for PVH")
> > from the xen-two tree interacting with commit 6f80b68e9e51 ("x86, mm,
> > Xen: Remove mapping_pagetable_reserve()") from the tip tree.  The
> > automatic merge left the moved version of the above line intact while it
> > should have been removed (I assume).
> >=20
> > I have added the following merge fix patch and can carry the fix as
> > necessary.
>=20
> Ah yes. Please do. I will fix it up once I am back on the box that has
> access to the kernel.org. Thanks again!
>=20
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 4 Feb 2013 15:08:33 +1100
> > Subject: [PATCH] xen: fix bad merge of arch/x86/xen/mmu.c
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  arch/x86/xen/mmu.c | 1 -
> >  1 file changed, 1 deletion(-)
> >=20
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 824706a..3228600 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -2210,7 +2210,6 @@ void __init xen_init_mmu_ops(void)
> >  		pv_mmu_ops.flush_tlb_others =3D xen_flush_tlb_others;
> >  		return;
> >  	}
> > -	x86_init.mapping.pagetable_reserve =3D xen_mapping_pagetable_reserve;
> >  	pv_mmu_ops =3D xen_mmu_ops;
> > =20
> >  	memset(dummy_mapping, 0xff, PAGE_SIZE);

I am still carrying this merge fix patch and from a quick look, your tree
should need it now to even build ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__3_Mar_2013_02_39_59_+1100_=qmIkPVWX/ECjZqz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMh1PAAoJEECxmPOUX5FEs5cP+wZfx5nBS/TOAr0LzDMKNwP6
Ckk8UjhvzBdSHeeEIIZSqVI953/bV37wCDzBMLplbppBk3mTIoZ/KMQ4OEah4WdR
yzlj8XTIwMMor2C5ZOxZC3jFyVedTCyLTrsbWLMm9QG+xOWzTw5uizGHF30NoWx7
lB2Hdx/Dbhejg5nR6cruYgIgTS14CM/TiWmNJlljIp8D6VBKgW3g4epjyGD33Njq
7Xr+MjK9Bj/ZjmqEiwMT2SDPadZGK/XlXAAoFRBegl7Kv6pdTPBwP5ie+8imct3e
JCo87SGt0vJIa2Ze4DQ79GeBqBf42EG7V7n/QU12VeQHqGeH+sd+COvL/ZdXiqTd
yoHi0Pth2nf5pA/hQjr/8JCuBfKsbNCEuH3h4yZbfLPU3x/Sln/2FnVpu8it173z
vmtJNU9ouOjzSUUFiYgoXUeyML4xGayaCyVZn3Ey/WpmkqM4S/zzKPp9NoTVbB06
pMjPL9F+ALCiYMViocPoh67PsMZGJnwoLhlq3wj0yVGsMyH3wtK7ogPT0bVvS0Kz
jaWCSQTCa+rIIm+/zpE0ak52UTRaswKtfGjofpRp2tu5O6B5kLxR2NhWP10JsUrY
2hppT88ND65YXaIInei+hLSPM+R+Qbox4WTnClrJX4VJTKm3Uwe9P4YypikIefvP
INpPRazoJLmk1nt+64h1
=91cX
-----END PGP SIGNATURE-----

--Signature=_Sun__3_Mar_2013_02_39_59_+1100_=qmIkPVWX/ECjZqz--
