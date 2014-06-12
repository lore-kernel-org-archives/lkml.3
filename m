Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaFLCOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 22:14:16 -0400
Received: from ozlabs.org ([103.22.144.67]:55936 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbaFLCOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 22:14:14 -0400
Date: Thu, 12 Jun 2014 12:14:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@web.de>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20140612121405.29828461@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mutqB3Sa9oEFTbX8sn6949V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mutqB3Sa9oEFTbX8sn6949V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/bridge/br_multicast.c: In function 'br_multicast_has_querier_adjacent':
net/bridge/br_multicast.c:2248:25: error: 'struct net_bridge' has no member=
 named 'ip6_other_query'
   if (!timer_pending(&br->ip6_other_query.timer) ||
                         ^
In file included from include/linux/idr.h:18:0,
                 from include/linux/kernfs.h:14,
                 from include/linux/sysfs.h:15,
                 from include/linux/kobject.h:21,
                 from include/linux/device.h:17,
                 from include/linux/dma-mapping.h:5,
                 from arch/powerpc/include/asm/machdep.h:14,
                 from arch/powerpc/include/asm/archrandom.h:6,
                 from include/linux/random.h:81,
                 from include/linux/net.h:22,
                 from include/linux/skbuff.h:27,
                 from include/linux/if_ether.h:23,
                 from net/bridge/br_multicast.c:15:
net/bridge/br_multicast.c:2249:25: error: 'struct net_bridge' has no member=
 named 'ip6_querier'
       rcu_dereference(br->ip6_querier.port) =3D=3D port)
                         ^
net/bridge/br_multicast.c:2249:25: error: 'struct net_bridge' has no member=
 named 'ip6_querier'
       rcu_dereference(br->ip6_querier.port) =3D=3D port)
                         ^
In file included from include/linux/err.h:4:0,
                 from net/bridge/br_multicast.c:13:
net/bridge/br_multicast.c:2249:25: error: 'struct net_bridge' has no member=
 named 'ip6_querier'
       rcu_dereference(br->ip6_querier.port) =3D=3D port)
                         ^
net/bridge/br_multicast.c:2249:25: error: 'struct net_bridge' has no member=
 named 'ip6_querier'
       rcu_dereference(br->ip6_querier.port) =3D=3D port)
                         ^
In file included from include/linux/idr.h:18:0,
                 from include/linux/kernfs.h:14,
                 from include/linux/sysfs.h:15,
                 from include/linux/kobject.h:21,
                 from include/linux/device.h:17,
                 from include/linux/dma-mapping.h:5,
                 from arch/powerpc/include/asm/machdep.h:14,
                 from arch/powerpc/include/asm/archrandom.h:6,
                 from include/linux/random.h:81,
                 from include/linux/net.h:22,
                 from include/linux/skbuff.h:27,
                 from include/linux/if_ether.h:23,
                 from net/bridge/br_multicast.c:15:
net/bridge/br_multicast.c:2249:25: error: 'struct net_bridge' has no member=
 named 'ip6_querier'
       rcu_dereference(br->ip6_querier.port) =3D=3D port)
                         ^

Caused by commit 2cd4143192e8 ("bridge: memorize and export selected
IGMP/MLD querier port").  This build has CONFIG_IPV6 not set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mutqB3Sa9oEFTbX8sn6949V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTmQzyAAoJEMDTa8Ir7ZwVoasP/18eb3g7lmiVBUH2WNK8HXbU
sl9xTFefW5j0nTV1ZdmgTuukxoyj9LpykAywo+e90MXk44ABXpTTh7vTUO5jTf9D
v7ivmd3illypy//r49iSa5KMbqYVmSZAOy9yELdxiwAlppWnz5tlkyHwQ+H0v/z0
4YIKYj1lcXdKR1jlnyJCRYHAHgM5DuYUSMtrQafI1DcgYdC1GxHFUU4lQF20P+8k
Jy5igjz6PB6GdahaftXEE/jSOjdhnebP4F0tC+OkT/isLl26oJnSMcqvGLGmbWod
ZvUo4e1gCUSG/Nd0dA3vhWYTTqgCcDa/a27hLysVZ7Sk9NyzJLg4b498FJbris3S
1T/+aL/0vsSIirjj/LXGKeQC57jaBU5fZGbAWLaE0mvKJxofLQL9tACZkuvEEylg
NORS8K23IxsIdnPmwSMCE5oFvX0knUAXUakrKv7gT0KUeUmvmGxWBifYHcQ1jhnk
J06VoR83vkxOcQXq9CgTrGjbbTwgooxqNdvH+KHyrkoYTbq7osivFKaFK4mTiyI7
dm0mFWfWyXnGH9y1z/2A7w7DHUM1+mOd2MKHj0eqXHKIPlHBPFbSLMlGFo2rArh6
woxPVBefrKair5oQwxKESjW4gQvcwQapsb/RVyxC2U+bZYYKEBoFYNnNMdRv+nxw
dUS7exuBWlsMCXssRGOq
=LMOH
-----END PGP SIGNATURE-----

--Sig_/mutqB3Sa9oEFTbX8sn6949V--
