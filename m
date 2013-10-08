Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3JHJzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:55:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42295 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab3JHJzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:55:02 -0400
Date: Tue, 8 Oct 2013 11:52:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@suse.de>,
        Baruch Siach <baruch@tkos.co.il>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mpc85xx_edac: Remove unused function
Message-ID: <20131008095257.GC19633@ulmo.nvidia.com>
References: <1381158835-10804-1-git-send-email-treding@nvidia.com>
 <20131008063901.GA32409@jtlinux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <20131008063901.GA32409@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 08, 2013 at 08:39:02AM +0200, Johannes Thumshirn wrote:
> On Mon, Oct 07, 2013 at 05:13:55PM +0200, Thierry Reding wrote:
> > Commit 905e75c (powerpc/fsl-pci: Unify pci/pcie initialization code)
> > removed the struct platform_driver that held the last reference to the
> > mpc85xx_pci_err_remove() function. Remove the function since it is
> > effectively dead code.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/edac/mpc85xx_edac.c | 23 -----------------------
> >  1 file changed, 23 deletions(-)
> >
> > diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> > index 3eb32f6..b1e7106 100644
> > --- a/drivers/edac/mpc85xx_edac.c
> > +++ b/drivers/edac/mpc85xx_edac.c
> > @@ -326,29 +326,6 @@ err:
> >  	return res;
> >  }
> >  EXPORT_SYMBOL(mpc85xx_pci_err_probe);
> > -
> > -static int mpc85xx_pci_err_remove(struct platform_device *op)
> > -{
> > -	struct edac_pci_ctl_info *pci =3D dev_get_drvdata(&op->dev);
> > -	struct mpc85xx_pci_pdata *pdata =3D pci->pvt_info;
> > -
> > -	edac_dbg(0, "\n");
> > -
> > -	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR,
> > -		 orig_pci_err_cap_dr);
> > -
> > -	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, orig_pci_err_en);
> > -
> > -	edac_pci_del_device(pci->dev);
> > -
> > -	if (edac_op_state =3D=3D EDAC_OPSTATE_INT)
> > -		irq_dispose_mapping(pdata->irq);
> > -
> > -	edac_pci_free_ctl_info(pci);
> > -
> > -	return 0;
> > -}
> > -
> >  #endif				/* CONFIG_PCI */
> >
> >  /**************************** L2 Err device **************************=
*/
> > --
> > 1.8.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Hi Thierry,
>=20
> Sorry, but I already have this patch in
> http://lkml.indiana.edu/hypermail/linux/kernel/1309.2/03410.html

No worries.

Thierry

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSU9X5AAoJEN0jrNd/PrOhLzcQAKNuuv7ILD65nbXNpbgwtmjY
YHBiKtx+/03Q1mEj2lQxi8y4+ttgtkChsd6O2rNwFdP7tZ7hK22vyC7dQRSLncGj
ZFsIeq9fxlhEat+OCGPwdrgRxDjEO4SoJf+XltgpOE3XzdGnu1dPqvBnwf/awcb5
x+VCjyBWSQCjaFURXY8gXxXB46+lJ4Z32Fop8YJsyZMMjDjb500HrUK5TyOL580Z
8Kj0aaMOp3X70gQWgMNEVX9zUvHcQc4xmmhiaMzEXF/a8A+x3fGeSgJNhDMdQUL5
3lV3r259TR2dsY49aUqLlrjVSM8ReYuJxvDUTz9B+OWlLj9qYfhIDADm3vN+tBSH
UUq6dqfb7V+lJFRugQcd1LfFB6yUfykUR9u8OfJlTB7TuOeeBrpX95dGtIhDTxCD
NVQkLHJ0YoT/1DfAbwhonC6lE6SuzkUMfP3dQwThBEhyw9qXDv7zvPP+ZVF/7hxM
WwJAM2tT40CwEFN1P6ZDXaMu01011iSlq/9t/I6buJLtdasVMHUCBlTzB6ASNeJ4
AkiEIRIsWez8f5ztu23RFnoitzOMwLJ3vZEBGEGX58Eb+ypgL4RAlBHHXIiifSNa
hl6OwaYK0HBSCWfE2ktR5JdBmQAsgQHpaxjs3yF2wQNpsF+DTlQ/jnfhHH7yrDRi
IWNAZWFMOIx3ToBl2C3/
=MJ2f
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
