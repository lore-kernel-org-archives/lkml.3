Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaLOXKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:10:08 -0500
Received: from ozlabs.org ([103.22.144.67]:50452 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaLOXKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:10:06 -0500
Date: Tue, 16 Dec 2014 10:09:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: George Spelvin <linux@horizon.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH v2] VERIFY_OCTAL_PERMISSIONS: Move to <linux/sysfs.h>
 where it belongs
Message-ID: <20141216100957.6f42e898@canb.auug.org.au>
In-Reply-To: <87egs1d0rk.fsf@rustcorp.com.au>
References: <20141206032310.27123.qmail@ns.horizon.com>
	<87egs1d0rk.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=/fxWpQgYbXi85Mx9Tw+gtY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=/fxWpQgYbXi85Mx9Tw+gtY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi George,

On Mon, 15 Dec 2014 14:26:15 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> George Spelvin <linux@horizon.com> writes:
> > It's the only user of <linux/bug.h> in kernel.h, so that reduces
> > the compile-time cost of #include <linux/kernel.h>
> >
> > Only one user has to change: <linux/moduleparam.h>.  The <linux/types.h>
> > there is needed for one function prototype that passes s16 parameters.
> > My first reaction is to wonder if that can be gotten rid of, too.
> >
> > Some other extraneous header files pruned while I was at it.
> > Tested with allyesconfig & allmodconfig on x86-64, just to
> > be sure.

Please do *not* mix changes up like this.  Split this out into a
separate patch, please (1 logical change per patch).  And testing only
on x86_64 is not "sure" when talking about header file pruning (but at
least you did the "all" configs).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/=/fxWpQgYbXi85Mx9Tw+gtY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj2pKAAoJEMDTa8Ir7ZwV8ukP/0Osz9LD1/7XWUZQlpCkyiDo
jMJTs0+0eu1Z/Uk2rns86Gsj6u/84dc3uK5dKyDFw4Fdr5pYj2DqX1X0wR3Jxn47
LR721o28ywJ/DdhLyS9HX5iMTS1PkKy8utxI3VskfScpj7Q0LO+ow+VCJ3dlDrz/
ILPohEffwycv5W8W8EHbPuOFyw0Iqgw0ryYyVlg/xiLUCUsDjYUM40+KQqjMZ/JS
/fOgX7A1uPZvV9nGBsZRmGwdiQHOVCcivYxLSBx391nw192TR8Ag4NLk0HTO4VpN
f9BtS0eAM8GrKBCS/Iyk4F3PsBXwaDLDkCzNiny2VQ77JvZlhAnldp8gyqaw2hIN
fNIdAY4jU6MwDI0XlBR34Gelhp64me3EQQeCvqp25Rv02sKKHeW9G2qou6od5RLL
hh7v67MTS3hLG37JWXKRgOEepiQlzstqaMju0wtuDZwptWwLd21Yj7PUZNL/55VV
T6tEYIT1/UQyOXNhn6GACH0m3Stq38pG5IhjKwRGkej0eI05VcxWLiacf3aDd6/f
jfQPMhfDSRcwA/+HOHDa1U+XkUZgMM72Oo5/iSR32+w5SjUf1sXUrwvOeaTxIlGm
r1sPMbL7HIUWNaR5emjaBzJ9xFDvbjgxr+4iaGSwdrS8lHob8T17CIT5PfZi6jV0
B24AnDsxWdJ/c77iSJ4e
=MAyB
-----END PGP SIGNATURE-----

--Sig_/=/fxWpQgYbXi85Mx9Tw+gtY--
