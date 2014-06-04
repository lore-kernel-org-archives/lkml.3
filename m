Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaFDNP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:15:59 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:54392 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaFDNP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:15:56 -0400
Date: Wed, 4 Jun 2014 15:13:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH v2 6/6] usb: host: ohci-exynos: Use devm_ioremap_resource
 instead of devm_ioremap
Message-ID: <20140604131306.GB28484@ulmo>
References: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
 <1399723210-21569-7-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iFufCh6SVEF-HQA62ZsJGJGSebDSs28eqcrMy1X8e5vjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <CAFp+6iFufCh6SVEF-HQA62ZsJGJGSebDSs28eqcrMy1X8e5vjA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 03:41:20PM +0530, Vivek Gautam wrote:
> Hi,
>=20
>=20
> On Sat, May 10, 2014 at 5:30 PM, Vivek Gautam <gautam.vivek@samsung.com> =
wrote:
> > Using devm_ioremap_resource() API should actually be preferred over
> > devm_ioremap(), since the former request the mem region first and then
> > gives back the ioremap'ed memory pointer.
> > devm_ioremap_resource() calls request_mem_region(), therby preventing
> > other drivers to make any overlapping call to the same region.
> >
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>=20
> Although this patch and rest in the series are merged.
> But i have got a doubt, so making this thread alive.
>=20
> > ---
> >  drivers/usb/host/ohci-exynos.c |    7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exy=
nos.c
> > index 9cf80cb..dec691d 100644
> > --- a/drivers/usb/host/ohci-exynos.c
> > +++ b/drivers/usb/host/ohci-exynos.c
> > @@ -120,10 +120,9 @@ skip_phy:
> >
> >         hcd->rsrc_start =3D res->start;
> >         hcd->rsrc_len =3D resource_size(res);
> > -       hcd->regs =3D devm_ioremap(&pdev->dev, res->start, hcd->rsrc_le=
n);
> > -       if (!hcd->regs) {
> > -               dev_err(&pdev->dev, "Failed to remap I/O memory\n");
> > -               err =3D -ENOMEM;
> > +       hcd->regs =3D devm_ioremap_resource(&pdev->dev, res);
>=20
> Here, we replaced devm_ioremap() call with devm_ioremap_resource(),
> which internally requests the memory region

I guess this could lead to problems if drivers haven't been written to
cleanly split the register ranges that they access, since now two
overlapping regions may be requested and cause the drivers to fail.

> and then does a "devm_ioremap()" or "devm_ioremap_nocache()" based on
> the check for IORESOURCE_CACHEABLE flag.
>=20
> But this flag is not set for the resource of this device.
> So should we be explicitly setting the flag in driver ?

I don't think it makes much sense to map these registers cached anyway.
Drivers will likely expect writes to this region to take effect without
needing any kind of flushing.

Thierry

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjxtiAAoJEN0jrNd/PrOhiTYP/2NPPViprewJ60qZhUc+hJ7G
hMv0Qa08HrSeNLnHN/jOqIwdgDMFSy/8Um2yCyqH5Wpy0+ohJL2V0PuBuXA/ZIbO
ZQ6Q3CChqGxqc939kaVjoeLYlNJCPaz2lkxqGHpuSLDY9ojIbbHgfPbEVFeQj6Z4
6+VkGh06/+Ato8Rpp5xmzr77x9qujLzGPe6e8zS7cr272TwBXBgBGo/jUBHt4aE1
EKo4TQtVfkBXIeSqvSKBXQSxVq3ADWOS5EOl7o0MTfoxd/2DKt3Ktd8SFisvBCWQ
aGu6QjHIaEMiAjmAwIYSTZW9Djw1x62xgdRA/ZFQufLJK2anwxgKv+jEz0Fz1XPu
LSJCGiCWzma9IywPEc5abTRSsfIYI6iQJxwq7Fg4Z2ssLII6aPljyozbUm81YjxS
ViB8OtzJnUjqcpca2UmDfvuG3Ty3LgyH+mopNP28daMcEeY4LczBX/Pk3uftS2Nm
+s+Whk9Ssv1WNlYz4nq737PuwnZ8leSf8hhfPDqWh9Zw8mZ/F8Cv/jqWEF7vK7ar
lckvyWfGH/9CYqZu/WYgzid70hO4T32SnS+sJiqx/6/oGqI1bVEc+JVcNherwL88
azmSggvCzovSD9B9Tlp4Bu2Lj7tSfsmHPIOvf5CVsKUHWWJYT6egfnm/vin2Y2L3
+3awh4NG713uFf5l4gfm
=1dt2
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
