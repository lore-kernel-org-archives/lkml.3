Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbaGOFz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 01:55:57 -0400
Received: from ozlabs.org ([103.22.144.67]:41038 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaGOFzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 01:55:54 -0400
Date: Tue, 15 Jul 2014 15:55:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140715155547.25959587@canb.auug.org.au>
In-Reply-To: <53C4BF8E.4010509@roeck-us.net>
References: <20140715132946.771def89@canb.auug.org.au>
	<53C4BF8E.4010509@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nhdjPNs9e4c5Noeh5l8+4ib"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nhdjPNs9e4c5Noeh5l8+4ib
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Mon, 14 Jul 2014 22:43:42 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 07/14/2014 08:29 PM, Stephen Rothwell wrote:
> >
> > After merging the v4l-dvb tree, today's linux-next build (powerpc ppc64=
_defconfig)
> > failed like this:
> >
> > arch/powerpc/kernel/smp.c:764:2: error: initialization from incompatibl=
e pointer type [-Werror]
> >    { cpu_smt_mask, powerpc_smt_flags, SD_INIT_NAME(SMT) },
> >    ^
> > arch/powerpc/kernel/smp.c:764:2: error: (near initialization for 'power=
pc_topology[0].sd_flags') [-Werror]
> >
> > Caused by commit 6a0b50087a89 ("Merge branch 'patchwork' into
> > to_next").  The change to include/linux/sched.h in this merge commit
> > does not seem to appear in either of the parents of the merge.
> >
> > Its also a change that (when suggested) was shown to cause more
> > problems than it was worth and dropped.  I can't imagine how it ended
> > up in the merge commit.
> >
>=20
> Do you mean b6220ad66 (sched: Fix compiler warnings) ? I thought that was=
 accepted
> a week or so ago.

That is in the tip tree and includes the fixups to powerpc and arm.  I
don't merge the tip tree till well after the v4l-dvb tree.  The merge
in the v4l-dvb tree included only the change to include/linus/sched.h
and neither parent fo that merge was based on the tip tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/nhdjPNs9e4c5Noeh5l8+4ib
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxMJnAAoJEMDTa8Ir7ZwV3ykP/1KC6Mmp7crgth0cs2ptk4D8
cpHUdhAI5t8jA1L5WayReEfiNlAos9sn7+ubP3c8Tl6SrSBGQO0Ah/86lSmdZRU/
YJZeK/FE9sheuBM+iU/BHiWAl7gtE86Gsn/kWf+6XmnQ3sd0gYoqoptujazygS3l
QgAtjPlYPjnXilH4GVLlT9URiNc0sSRR3fkwn0wtbEvECT+1ZscTFooEMHCuAJV1
gQJUok71ql4DOp1pCyXHUiSJrSK8HbxoKOFsW+fE0A7S7AWumNq4v867oWuwU2aL
erz9Hc/Nmz1VNkULOd3pa/fCVLvRVm4866PvMGs2PFv2X3F4q82/TQknH0eNpjDK
VvVW7cAj2SIu14S05eH2M9AIpUinwOZlulLf2g3wtWqvfRmlxZ0fu1d01mybqpgk
TOaTwX8VCT2psu2mG9BqGAlunuI7oayFdwzedR3vUJMIWXXLQHKs/nxphPGFkaa0
FUabZYVJhU5YlhO0fUUjbDo4f4ucyv+70SrV2LJVDJT8F0jb/RKrl4ao0FVVR08f
cmdSOCOQtFTp9u3z0pC31yVHo/D2oPMtgf7HbSbmffl2kJZYAL6VbcZnKehgN07Z
vtK57R5PL1dGjJTXN0lm2ohZzQ2lBgnG706kQMd9qh5H2zearF0tNxFkRj7VwGba
qfUJX2L4pwAT2QtaoYOt
=qLRB
-----END PGP SIGNATURE-----

--Sig_/nhdjPNs9e4c5Noeh5l8+4ib--
