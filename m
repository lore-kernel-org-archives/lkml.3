Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3L0JDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:03:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:15178 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab3L0JDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:03:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,559,1384329600"; 
   d="asc'?scan'208";a="456391524"
Message-ID: <1388135003.2183.145.camel@jtkirshe-mobl>
Subject: Re: [PATCH 2/2] ixgbe: set driver_max_VFs should be done before
 enabling SRIOV
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, davem@davemloft.net,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Dec 2013 01:03:23 -0800
In-Reply-To: <1387901251-1672-1-git-send-email-ethan.kernel@gmail.com>
References: <1387901251-1672-1-git-send-email-ethan.kernel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-w8qPRrrI0g8Z0RHX0NYt"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w8qPRrrI0g8Z0RHX0NYt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-12-25 at 00:07 +0800, Ethan Zhao wrote:
> commit 43dc4e01 Limit number of reported VFs to device specific value
> It doesn't work and always returns -EBUSY because VFs ware already
> enabled.
>=20
> ixgbe_enable_sriov()
>         pci_enable_sriov()
>                 sriov_enable()
>                 {
>                 ... ..
>                 iov->ctrl |=3D PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
>                 pci_cfg_access_lock(dev);
>                 ... ...
>                 }
>=20
> pci_sriov_set_totalvfs()
> {
> ... ...
> if (dev->sriov->ctrl & PCI_SRIOV_CTRL_VFE)
>                 return -EBUSY;
> ...
> }
>=20
> So should set driver_max_VFs with pci_sriov_set_totalvfs() before
> enable VFs with ixgbe_enable_sriov().
>=20
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Ethan, I have added this patch as well to my queue.

--=-w8qPRrrI0g8Z0RHX0NYt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSvUJbAAoJEOVv75VaS+3OFf0P/3A2eH7tHcNsfM0FtBH/iFGj
PBKsJ+z4ObPUCmQoJEiVUHM9N6cpfYs9aD0ph9ktfAN9N2tvxfiKR+CXUetS+RYL
WqAM+35Uhy4b26MyceLn/0Xeo3V3de7aZuWgmRPvVWrZkuOOooj8J6CUusqihuvh
NGKwZ/PAB/ZuZ1frhndy8rBZRlkxxJpYt7j40jZlARoay4/LmuPZhM0fEZSpIPCq
SwkI0WsPewnwH+0u95b8QSMYXYMF/UP5PgkXf1O7pzgsW3hVHmU9AiiPwJXSf4eq
zMiF2OLrPU61DnOFb58oEfHvPCwrYO6GkJ6CvZtrH9LKQJmreZaJMRVFnjc44vSe
GmtmcMda8QpOvrfuboDxkM4X/zVsdv2RZKbuoiYit/mh7ZS9ohlYGRQgrA8DlMP2
XgDmq3TZq/QTbDe2o3yzBmRi8CfNufgrUS8eolk9es/OH9hxjV+DHAWFsM7ZBEce
DC/5EUG9X24x2E7gCKbxv/V6+Hf58qhMYfg9VbENczXo/Rhp4XZzyveqEWQCOQCV
1sIoCXlIMudzWAJNXxjSKY0YMlkjXe3kzT9CCIQCtrGcBo5PbrAhuQEnUPW23X00
An6img9c5HSwp54A8Po5NnRoWZb14vlOG+P73wQLzEcYRnYyhc0VX3bVXuszXVyl
Q/dNNac4yhMyeF13YkDP
=5G+d
-----END PGP SIGNATURE-----

--=-w8qPRrrI0g8Z0RHX0NYt--

