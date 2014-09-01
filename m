Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaIAHH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:07:57 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8026 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaIAHHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:07:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 01 Sep 2014 00:06:39 -0700
Date: Mon, 1 Sep 2014 09:07:49 +0200
From: Thierry Reding <treding@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Shaik Ameer Basha" <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, "Joerg Roedel" <joro@8bytes.org>,
        Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "Tomasz Figa" <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/29] drivers: add DRIVER_HAS_OWN_IOMMU_MANAGER flag
Message-ID: <20140901070748.GA24226@ulmo.nvidia.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <1407235677-26324-11-git-send-email-m.szyprowski@samsung.com>
 <54040298.9020002@samsung.com>
MIME-Version: 1.0
In-Reply-To: <54040298.9020002@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2014 at 07:22:32AM +0200, Marek Szyprowski wrote:
> Hi Greg,
>=20
> On 2014-08-05 12:47, Marek Szyprowski wrote:
> > This patch adds a new flags for device drivers. This flag instructs
> > kernel that the device driver does it own management of IOMMU assisted
> > IO address space translations, so no default dma-mapping structures
> > should be initialized.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >   include/linux/device.h | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 5f4ff02..2e62371 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -253,6 +253,8 @@ struct device_driver {
> >  =20
> >   /* disables bind/unbind via sysfs */
> >   #define DRIVER_SUPPRESS_BIND_ATTRS	(1 << 0)
> > +/* driver uses own methods to manage IO address space */
> > +#define DRIVER_HAS_OWN_IOMMU_MANAGER	(1 << 1)
> >  =20
> >   extern int __must_check driver_register(struct device_driver *drv);
> >   extern void driver_unregister(struct device_driver *drv);
>=20
> Could you comment if the approach of using flags in the struct driver
> could be accepted? I've converted suppress_bind_attrs entry to flags to
> avoid extending the structure, please see patch "[PATCH 05/29] drivers:
> convert suppress_bind_attrs parameter into flags".

Is this really necessary? What I did as part of an RFC series for Tegra
IOMMU support is keep this knowledge within the IOMMU driver rather than
export it to the driver core.

The idea being that the IOMMU driver wouldn't create an ARM DMA/IOMMU
mapping by default but rather allow individual drivers to be marked as
"kernel-internal" and use the DMA/IOMMU glue in that case. Drivers such
as DRM would use the IOMMU API directly.

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBBtEAAoJEN0jrNd/PrOhF3MP/1ssXeNRPb3m/7VTznB7wung
9DLRtgN4WVUDwhx0MRhDB6O4k3Jb667azWOBis8NIal5mcc0Vapoy4CiJKdt/piv
t5FwD0xgo41avHjgvw+x1YNxwsiavBCBKuVZp80JaHYIfIV4E+T9V/gFfgK+ZWhQ
i2lE7VAYkUaDk4JLIDhTkYjn/1Onftsw+WT7imGSmZ9vQ0r7Yu27rOhs8pB59Adu
7La8FMcL7L58Q5BDcSeemQu4ajxIakDhXOtvfSpM0VbC/JV/nW+DaRkxW7gf8VsF
aRH31I42pssQDcEBoHLrK5igHUH7VDSwitMEUtVMTPx7jm+uKn3bWEw/z69hn9a2
2YvRZofQAaGxsl9okoFuOM1XBsxEytjJgfcAAI2uKEv7jNjlOV+0vILhzYsCqe4N
nUzSYwR0Hmk3YRwZPiGiQBbBcRRstVyLswR0zGnZrq1Eerf7PrSn+KveJ7Hw6rZL
l2wjSyr4X6k5ovI9HFslCnh494cIPX6qAyjnHaINMkGwGuVKO3CexWXejvVBMZQD
13QVm9MA50Qya9syIdQC4KYJTgcLAzt4ipDKGN4R9hFSuzM8vyJol/XQVURNQSs5
j1+G9TMdgDjPV1ayR529Fm95vGFAA6jbu29LRhzq5xAaplAFUNrGT9swgjJGK1im
iBwJIbSbueWALvGLJT9K
=U8N1
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
