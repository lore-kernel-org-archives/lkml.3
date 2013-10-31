Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3JaXJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:09:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44248 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3JaXJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:09:31 -0400
Date: Fri, 1 Nov 2013 10:09:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@akamai.com>, paulmck@linux.vnet.ibm.com,
        normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] epoll: remove the on_list check for 'struct epitem'
Message-Id: <20131101100912.1d83667289bcca24c882b109@canb.auug.org.au>
In-Reply-To: <20131030183241.AE8201FF9@prod-mail-relay06.akamai.com>
References: <20131030183241.AE8201FF9@prod-mail-relay06.akamai.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Nov_2013_10_09_12_+1100_sN8BrDkZn=uRgawh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Nov_2013_10_09_12_+1100_sN8BrDkZn=uRgawh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 30 Oct 2013 18:32:41 +0000 (GMT) Jason Baron <jbaron@akamai.com> wr=
ote:
>
> By removing the 'int on_list' field from 'struct epitem', we avoid hittin=
g the
> BUILD_BUG_ON() for 'struct epitem' being larger than 128 bytes.
>=20
> In file included from include/linux/init.h:4:0,
>                  from fs/eventpoll.c:14:
> fs/eventpoll.c: In function 'eventpoll_init':
> include/linux/compiler.h:321:20: error: call to '__compiletime_assert_213=
7' declared with attribute error: BUILD_BUG_ON failed: sizeof(void *) <=3D =
8 && sizeof(struct epitem) > 128
>     prefix ## suffix();    \
>=20
> The check to make sure that the 'struct epitem' was actually linked via
> epi->fllink was added to avoid having the list removal primitives called =
twice
> for the same 'struct epitem'. However, the double call possibility was re=
moved
> by 'Subject: epoll: optimize EPOLL_CTL_DEL using rcu'. There, the call to
> 'list_del_init()' in eventpoll_release_file() was removed (we now rely on=
 the
> list delete happening entirely in 'ep_remove()', which is called from
> eventpoll_release_file()).
>=20
> There is also the question as to whether multiple ep_remove() calls could
> happen concurrently. This can not happen since EPOLL_CTL_DEL can't
> race with eventpoll_release_file() or ep_free() - it has to do an fget()
> to proceed. Further, eventpoll_release_file() can not race with ep_free(),
> since they both acquire the 'epmutex'.
>=20
> Signed-off-by: Jason Baron <jbaron@akamai.com>

Do you want me to put this in my copy of the mmotm instead of reverting
these three?

epoll-do-not-take-global-epmutex-for-simple-topologies-fix
epoll: do not take global 'epmutex' for simple topologies
epoll: optimize EPOLL_CTL_DEL using rcu

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Nov_2013_10_09_12_+1100_sN8BrDkZn=uRgawh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScuMeAAoJEMDTa8Ir7ZwVgecP/1QOy677wsozYJydA3IC6Ido
n3yQdFBIeh03TA2HjPujsKOaVWw24zfkB0EJhcqoIU+PUEda7/lWABJfrmKcqVIC
nfHydND4Fs776H9elhMs9C2gYxri7O0yrLeBSa4kfblnIQjOhHoMYzxCJAogaqu9
fvESaudsz6+D8qTMrfpLjMK/7VnZwb/6dlzwRkGNz2xyG5NYsu02SzFrRgNVENw6
9TTpLcUjU2V6Ne0Xr9u0BFYp5nJmFyxAHayFWVkKPY6zIhVDnEF6GgZejhDza9dU
KV4ayUMXtgYYmSQIhjosl6D4Vmp5xIjGuAL6qC8411Dc8TbwVZTnpUtMYZscXd+E
kOcEOkx+jH7scT1x+s+DeufENnWCtVz69o/gGG0+qOb57SHrunO+iilsffsqZbpc
1I43Mz6WCQQLew5iqGvMOZ+rvfxg2aLd8Kdg1P4APrikkyowrmSbYC100kBUSMRm
ENmRGG6Y6RAJ2j0uG7xVUWXl7iVlMsnphenshpMBjLzD+zpJTd9iTZkZTTKNsBTj
GORq9txKjpk3oxaU37lqxUez5X5OV8JKOGq5TYpc5iiazxGZu7nlQqV/E+OapKWt
4x21EvfgkP9qvJZrcgyiUFgjhcIml6um4ThEnuaA40oUo3p3fBsAeWShCDrzDECj
vegATiBeo5Bss0wh6fZR
=erMM
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Nov_2013_10_09_12_+1100_sN8BrDkZn=uRgawh--
