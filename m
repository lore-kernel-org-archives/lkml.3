Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaAFMFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:05:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:15985 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaAFMFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:05:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,612,1384329600"; 
   d="asc'?scan'208";a="460690486"
Message-ID: <1389009890.2278.3.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH net 2/2] net: core: explicitly select a
 txq before doing l2 forwarding
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Jason Wang <jasowang@redhat.com>, aaron.f.brown@intel.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Fastabend <john.r.fastabend@intel.com>,
        e1000-devel@lists.sourceforge.net, Neil Horman <nhorman@tuxdriver.com>,
        mst@redhat.com
Date: Mon, 06 Jan 2014 04:04:50 -0800
In-Reply-To: <1388978467-2075-2-git-send-email-jasowang@redhat.com>
References: <1388978467-2075-1-git-send-email-jasowang@redhat.com>
	 <1388978467-2075-2-git-send-email-jasowang@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-usxU0gsJzdZiHWGJRdcL"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-usxU0gsJzdZiHWGJRdcL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-01-06 at 11:21 +0800, Jason Wang wrote:
> Currently, the tx queue were selected implicitly in
> ndo_dfwd_start_xmit(). The
> will cause several issues:
>=20
> - NETIF_F_LLTX was forced for macvlan device in this case which lead
> extra lock
>   contention.
> - dev_hard_start_xmit() was called with NULL txq which bypasses the
> net device
>   watchdog
> - dev_hard_start_xmit() does not check txq everywhere which will lead
> a crash
>   when tso is disabled for lower device.
>=20
> Fix this by explicitly introducing a select queue method just for l2
> forwarding
> offload (ndo_dfwd_select_queue), and introducing dfwd_direct_xmit() to
> do the
> queue selecting and transmitting for l2 forwarding.
>=20
> With this fixes, NETIF_F_LLTX could be preserved for macvlan and
> there's no need
> to check txq against NULL in dev_hard_start_xmit().
>=20
> In the future, it was also required for macvtap l2 forwarding support
> since it
> provides a necessary synchronization method.
>=20
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: e1000-devel@lists.sourceforge.net
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   15 +++++++++----
>  drivers/net/macvlan.c                         |    3 +-
>  include/linux/netdevice.h                     |   11 +++++++++
>  net/core/dev.c                                |   28
> ++++++++++++++++++++++++-
>  4 files changed, 49 insertions(+), 8 deletions(-)

Thanks Jason, I have added this to my queue since it has changes against
ixgbe.

--=-usxU0gsJzdZiHWGJRdcL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJSypviAAoJEOVv75VaS+3OUMoP/2bcNAE+64dSKRQ8QR7a/lde
qUt+QH9Ft4LgN0SZPm28EnLffv86wH6OwOuhrKZ/ry9gt9QaC1ZkJuIDthzy7GWt
BWv0siuPTQvxHZMeQ56JHkSyxz5Ihz3YujGx0nrsBOvp5dAkvFjGiUjTy43MyvXL
7/g/r1ZkXogBdJBWkS/bUi48RBBRUqaaW2L3TUR3B42U/P6/9Q5HYW3kEBLR/YL+
Csw0IRxHAhWG+yGDSmlGeXykTdI7Qr7LDDyV9fVeE1hsSrCIKSC17Wup/Rrs5yLf
vmYEA3+LxAH6E8GYmdPuJm9rb9c+xLP9JCnZxZvByY+m1NaCjRKkRnksAHtZMcQ1
/LYDzjBzLm6ESxA5mUZghyaf92zmJgbbgFmyn3l0EYI1qhF8fFqMqdN8dZXPFICX
sKcozswKHrmSpBShXZmjJi97nPLVgdETMXu7oWQOCy4nCcFknjgYKMBe18y0SFAM
5wjZmKO9cWV37UeRtf2YzuTTD69PnTzjY++Et3RwyJ9TBMeaG/1hYD4x38OhUO9K
rIvDOJGiIOwKfjDGW19rPy/i1JpfMRmWGoqassZ+eWw38JuMUgQRvmHAjCAj+LqF
Mm9Tr5ctsdnP+WlrGfdT8jcjyOpMGsvY0oRZQ/dVXfTf/Xcvf4SNjgFpUYFL5gmD
H1ggGxqDV9NnyL/7mR9K
=GfAn
-----END PGP SIGNATURE-----

--=-usxU0gsJzdZiHWGJRdcL--

