Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaDGVvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:51:15 -0400
Received: from ozlabs.org ([203.10.76.45]:39020 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbaDGVvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:51:14 -0400
Date: Tue, 8 Apr 2014 07:51:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20140408075107.f13e69a4d08471656acfb9f3@canb.auug.org.au>
In-Reply-To: <20140407112654.e2172fd7c0df975bf79df388@linux-foundation.org>
References: <20140407145242.1958251349e0b6c6c8923f46@canb.auug.org.au>
	<20140407112654.e2172fd7c0df975bf79df388@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Apr_2014_07_51_07_+1000_.F8xZfcJqLi/MxG6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Apr_2014_07_51_07_+1000_.F8xZfcJqLi/MxG6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 7 Apr 2014 11:26:54 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Mon, 7 Apr 2014 14:52:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
>=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > fs/ocfs2/suballoc.c: In function 'ocfs2_block_group_set_bits':
> > fs/ocfs2/suballoc.c:1357:2: error: implicit declaration of function 'tr=
ace_ocfs2_block_group_set_bits' [-Werror=3Dimplicit-function-declaration]
> >   trace_ocfs2_block_group_set_bits(bit_off, num_bits);
> >   ^
> >=20
> > I have no idea how to track this down :-( The only patches affecting th=
is
> > code are now in Linus' tree.  I can only assume that some implicitly
> > included header file is no longer included.  I have just left it broken
> > for now.
>=20
> I can't reproduce this with either mainline or linux-next.  Pulled half
> an hour ago, powerpc allyesconfig.

Rats!  I think I have been fooled by my own scripts.  What was built here
was the result of me trying to merge your tree.  After abandoning the
attempt, my build tree did not get reset to the final linux-next before I
did my final build checks which include the powerpc allyesconfig.

Sorry about that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Apr_2014_07_51_07_+1000_.F8xZfcJqLi/MxG6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQx3QAAoJEMDTa8Ir7ZwV6JoP/3kQK5eZ4x22IWpmuZLj9Xjj
kWDc0uqpV7kAmbOW1pfb01ZQRzlwQIc6Yqy41lUhJRHQ3BLI3MNjwpD9g9pWCxlT
sJKQEA9p1GKd1R4nMvNNUYlbvIWtie4ccyIyVpBVWDxMz0Bm+72G3vDrEj/jXNjq
OrXNb674K88gJblPBtJGFgzDyZCxQ0bMCdCtuVLuymb4kGgU2PaHxp9tb0jM3oFd
aCC2TgA/1aqRW5Bm2qynWG1wdtEvuj04YtBhrLjunsmlP65ZRoncg/ESeTrF9LlM
WlkVtZElPJvuql7OB+FtS0oRXI9t+B7rqDU7j+oS/VOLGBcJ4xtv4qRrdjM3zqu6
QioH/piTiFop7al900REr5BqUK1aAT45O4g1K90Gv/QtsDPmQi0e5bWorUjPLFFm
5t/CdMU7mthmnJAS6hwC6wZlU8VDn4+OvAXODDQq5qFRpdyeRXLePiXPgZ4XwNJJ
En9UfKMC2x3z+Pn3ZxdtELNo0t2gbBKj24As6vdiggGO8RhTuf9+DoYSqk3Mv6By
D4CP8usoT6pivQ0DoUah4RLnWi/FDqSMqourH7ru/LsI/84UrzFj2ZxnLFtw6liS
AeBZ+81r7EoIT+dWdDR3z7/ISg3YSi0KvlW72GgHQhnc7rM5Uwh4XVvb8T2KhfKx
l9ccPxeCKnZm7F8sOKAM
=+Q7r
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Apr_2014_07_51_07_+1000_.F8xZfcJqLi/MxG6--
