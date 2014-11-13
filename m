Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaKMMZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:25:25 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53203 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbaKMMZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:25:24 -0500
Date: Thu, 13 Nov 2014 13:25:20 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@imgtec.com>, linux-mips@linux-mips.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] binfmt_elf: allow arch code to examine PT_LOPROC
 ... PT_HIPROC headers
Message-ID: <20141113122515.GF23422@ulmo>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
 <1410420623-11691-4-git-send-email-paul.burton@imgtec.com>
 <20141112134059.GA12619@ulmo>
 <20141113001618.GC3839@linux-mips.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7uYPyRQQ5N0D02nI"
Content-Disposition: inline
In-Reply-To: <20141113001618.GC3839@linux-mips.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7uYPyRQQ5N0D02nI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 01:16:19AM +0100, Ralf Baechle wrote:
> On Wed, Nov 12, 2014 at 02:41:04PM +0100, Thierry Reding wrote:
>=20
> > Hi Ralf,
> >=20
> > This commit showed up in linux-next and causes a warning in linux/elf.h
> > because it doesn't know struct file. I've fixed it locally with this:
> >=20
> > ---
> > diff --git a/include/linux/elf.h b/include/linux/elf.h
> > index 6bd15043a585..dac5caaa3509 100644
> > --- a/include/linux/elf.h
> > +++ b/include/linux/elf.h
> > @@ -4,6 +4,8 @@
> >  #include <asm/elf.h>
> >  #include <uapi/linux/elf.h>
> > =20
> > +struct file;
> > +
> >  #ifndef elf_read_implies_exec
> >    /* Executables for which elf_read_implies_exec() returns TRUE will
> >       have the READ_IMPLIES_EXEC personality flag set automatically.
> > ---
> >=20
> > Would you mind squashing that into the above commit to get rid of the
> > warning?
>=20
> To fix the warnings reported by sfr on powerpc64 this morning I moved
> most of the code added to <linux/elf.h> into fs/binfmt_elf.c.  That
> should also have taken care of the warnings you saw for ARM.

These changes didn't make it into today's next, but manually applying
them I can indeed verify that the build warning is gone.

Thierry

--7uYPyRQQ5N0D02nI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZKMrAAoJEN0jrNd/PrOhin0P/2QdZ2yXgtdvYvWELEmWLaQa
+xSc3Lznq4yKUQZIOFUnu5mlQCixXqQWt+IS0RYGJkwinSLWOP0HudLQ3mtdlfyp
suZMJXsUJsu7cHW6GxUvu6N+NBHZC8cZryVmOEmS72LE9i4JCAvv6zcL+DHv2nqA
VrK8iTymt/SOACSFjzqmOfjIBaFlDXOVCj6K70Jr6hrzXlvjzpR0Vzax1VjuhJtY
j2FepaaZ7TLfhrABBb2I/phE0JLKnKF9V3+fw9aAOLtvQl2VxVJX+2QKxXZmGlXN
3Af2yzlQfxYSpQ3GcamToqGTos+h+PqBJBRbNe1VYswcJ1niSXjX/utdHJ4NK6vl
qyucOEhuZF132qTVqQbIeGG8cztMHnXXxPNyY9ZumEhxEbICFXjxE2daywPtJZ5Z
RWsZ1ulbKY+H12Fa6hmLTsFDjCBtcfBNBWXtNnVY4IlvJCwXbDoItexjR9uVXzos
5whWtsHmb1lmmrgoBrI3bfULZSeSaxauQ2rOePAIosgHT7TdisETP8Ih7OBEkFP+
T/uWsfZAL93Vpt0hW5nfMvZpjzK5CAAOcfwceLrLTqTz4amO2eXRMZEnN0ebOEz3
NFV2Cy6FVk1cEvlSy8MDP9sBKdyFRXGHZBUhJwGue5AEz8Xzjs6q/drLZk52d26u
G6Z40dryPmObkfaOzyR9
=Qh9f
-----END PGP SIGNATURE-----

--7uYPyRQQ5N0D02nI--
