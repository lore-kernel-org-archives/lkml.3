Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3KUELD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:11:03 -0500
Received: from dspam.tip.net.au ([203.10.76.12]:35978 "EHLO members.tip.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753403Ab3KUELA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:11:00 -0500
Date: Thu, 21 Nov 2013 15:10:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 04/11] vfs: add renameat2 syscall
Message-Id: <20131121151044.8bbc8cbf38754803915471ef@canb.auug.org.au>
In-Reply-To: <1384952512-21600-5-git-send-email-miklos@szeredi.hu>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
	<1384952512-21600-5-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Nov_2013_15_10_44_+1100_GjqM.+1C+21Ft=BO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Nov_2013_15_10_44_+1100_GjqM.+1C+21Ft=BO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 20 Nov 2013 14:01:45 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> From: Miklos Szeredi <mszeredi@suse.cz>
>=20
> Add new renameat2 syscall, which is the same as renameat with an added
> flags argument.
>=20
> Pass flags to vfs_rename() and to i_op->rename() as well.
>=20
> All filesystems check flags and return -EOPNOTSUPP for unsupported flags.

Can we please consider doing this slightly slower (and avoiding
conflicts/missed new uses etc) by creating a new i_op callback and only
implementing this when necessary?

=46rom past experience, I can just about guarantee that the patch as it is
will cause conflicts (for me in linux-next if noone else) and a new use
case will turn up before (or during) the next merge window.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Nov_2013_15_10_44_+1100_GjqM.+1C+21Ft=BO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSjYfJAAoJEMDTa8Ir7ZwV3mkP/RLe/LcL76fE010xqkaCiYr5
8XNiS+fs6DAvuc0APSLnXJSUro6j371aY++clIw5t8ybsOsUYqPBuUAOokPY/PnH
pskXE9ydY5m9oDgJWAZac3WiVi0+t5qnvurGWezpj/xRuJz2WayVMEgcp6tvkZtQ
btStr0TU20H+W2qb/3yRgRj4jxAakZK/dcQfNREZWAGmSC4yWBd2NK5GUipUVSD6
5cm65RJHk/NLiKUVwAf67F/QTusDWpsQClpHGx+J6GkniLQD56cElQtJDJG2o/wK
VJgy6NvxauIWwoEyYZiHacnkmwBPFPLbINpmWlBD4vWwuNTrjPhK1Z8VBKUUSf6C
V3heNQY4UIqiXbkRMRS0wHWEcX91BEHuZ40+HqtNmX7c1hfWwvSaKVub8uqFX0Vj
187yovUdZ0XxYHBckpVur5eNiauyxmj6rVjOv/qlV7VpZCBGZ9sLL3YqfxWRZ5wg
xQJNy74Bg9adfyIVda+KXeCxkYBnuNoPfDd6/FfAE/80b9mDJ4p1YZ73YBPyspJC
oTXz2EdLbPe7Vu+C3w9x0tc4HdISTHjTSt5swg+oBKFT3mlyDZvuK3wIRwxuzj4k
POsxWTJVia893NdwJFjBmoVkZnESzHrns3dme5hj/vcD+j8ngkvSXjOuCdY5skFi
WrySUn4BEFaCfkKSwZXE
=R7YB
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Nov_2013_15_10_44_+1100_GjqM.+1C+21Ft=BO--
