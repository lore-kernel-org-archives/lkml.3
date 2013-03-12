Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3CLJwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:52:13 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56663 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab3CLJwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:52:11 -0400
Message-ID: <1363081924.10491.52.camel@mirsal-laptop1.mirsal.fr>
Subject: Re: [PATCH v2 3/3] drivers: android: binder: Remove excessive
 indentation
From: mirsal <mirsal@mirsal.fr>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 12 Mar 2013 10:52:04 +0100
In-Reply-To: <1363046657.3724.11.camel@joe-AO722>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-4-git-send-email-mirsal@mirsal.fr>
	 <1363046657.3724.11.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-oExwYLUTViW8X9f8NlH1"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oExwYLUTViW8X9f8NlH1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-11 at 17:04 -0700, Joe Perches wrote:
> On Tue, 2013-03-12 at 00:26 +0100, Mirsal Ennaime wrote:
> > Remove one level of indentation from the binder proc page release code
> > by using slightly different control semantics.
> >=20
> > This is a cosmetic patch which removes checkpatch "80-columns" warnings
>=20
> More trivia:
>=20
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android=
/binder.c
> []
> > @@ -3001,17 +3001,20 @@ static void binder_deferred_release(struct bind=
er_proc *proc)
> >  		int i;
> > =20
> >  		for (i =3D 0; i < proc->buffer_size / PAGE_SIZE; i++) {
> > -			if (proc->pages[i]) {
> > -				void *page_addr =3D proc->buffer + i * PAGE_SIZE;
> > -				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
> > -					"binder_release: %d: page %d at %p not freed\n",
> > -					proc->pid, i,
> > -					page_addr);
> > -				unmap_kernel_range((unsigned long)page_addr,
> > -					PAGE_SIZE);
> > -				__free_page(proc->pages[i]);
> > -				page_count++;
> > -			}
> > +			void *page_addr;
> > +
> > +			if (!proc->pages[i])
> > +				continue;
> > +
> > +			page_addr =3D proc->buffer + i * PAGE_SIZE;
> > +			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
> > +				"binder_release: %d: page %d at %p not freed\n",
> > +				proc->pid, i,
> > +				page_addr);
> > +			unmap_kernel_range((unsigned long)page_addr,
> > +				PAGE_SIZE);
>=20
> Please align single function call args to open parenthesis.
> Please fill to 80 chars where appropriate.

Fixed in v3, thanks!

> I think using %s, __func__ is better than embedded function names.
>=20
> like:
> 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
> 				     "%s: %d: page %d at %p not freed\n",
> 				     __func__, proc->pid, i, page_addr);
> 			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);

Indeed, however binder_release is not the name of the calling function,
nor is it further up the stack. You are probably right in that __func__
should be printed rather than binder_release as it is a bit misleading.

I'm adding a separate patch for this.

> Also for the binder folk:
>=20
> I think it's odd to use pr_info in binder_debug.
> Why not use KERN_DEBUG or pr_debug/dynamic_debugging?
>=20
> #define binder_debug(mask, x...) \
> 	do { \
> 		if (binder_debug_mask & mask) \
> 			pr_info(x); \
> 	} while (0)


I'd be happy to change it to use pr_debug if that is correct.

Best regards,

--=20
mirsal=20

--=-oExwYLUTViW8X9f8NlH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABCAAGBQJRPvrEAAoJEPePn+hK5bYQPL0H/jfC7G3Lt4bDJrGDI+s2nnKk
e5+/cZGeBgJDGCryI7OdigBtQ7i0nWF3CGdTqZrVEc8S0/5pe3jUF3G/DqUN+w1j
sXSS9NSh0ZYEr2gxe63Q1wXAqBrv03nNJlmYrn5V3TlYSWdc2Nyh0bDKxkiee2tI
b9yh9Fj0hbxtpf13+2R9Xwu1uiFibc7/MztL5NQY1LEzwRYzUAR9iQ/OtS7iz79E
gAueOrtKriKPojVseHEU7AapjJNLexcjO/7bZlROpP7GWFVP0p2kCWchzLXC/HFB
qCjin6/0BE2IHVgB/zSD29i7Mj9yLhPDbw70MMLAn+95SY0Y+J1FGbAF+zM7mIc=
=WIfN
-----END PGP SIGNATURE-----

--=-oExwYLUTViW8X9f8NlH1--

