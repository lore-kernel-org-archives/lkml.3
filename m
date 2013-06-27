Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3F0GsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:48:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56586 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0GsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:48:05 -0400
Date: Thu, 27 Jun 2013 16:47:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 3/8] vfio: add external user support
Message-Id: <20130627164752.657c165ec4492e5248945a51@canb.auug.org.au>
In-Reply-To: <1372309356-28320-4-git-send-email-aik@ozlabs.ru>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
	<1372309356-28320-4-git-send-email-aik@ozlabs.ru>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_16_47_52_+1000_NRdURYob4XRbPIqC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_16_47_52_+1000_NRdURYob4XRbPIqC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexy,

On Thu, 27 Jun 2013 15:02:31 +1000 Alexey Kardashevskiy <aik@ozlabs.ru> wro=
te:
>
> index c488da5..54192b2 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1370,6 +1370,59 @@ static const struct file_operations vfio_device_fo=
ps =3D {
>  };
> =20
>  /**
> + * External user API, exported by symbols to be linked dynamically.
> + */
> +
> +/* Allows an external user (for example, KVM) to lock an IOMMU group */
> +static int vfio_group_add_external_user(struct file *filep)
> +{
> +	struct vfio_group *group =3D filep->private_data;
> +
> +	if (filep->f_op !=3D &vfio_group_fops)
> +		return -EINVAL;
> +
> +	if (!atomic_inc_not_zero(&group->container_users))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_group_add_external_user);

You cannot EXPORT a static symbol ... The same through the rest of the
file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Jun_2013_16_47_52_+1000_NRdURYob4XRbPIqC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRy+AbAAoJEECxmPOUX5FEfIgQAJxjfQ2mudNOZb4aylAKVAyl
Z3bpuGqlym9KU9gWJ7NPwGfaea3rH7MQ0Tzjvgn4BKjIJ8UYo2Oao6n6fRivCZSb
M14eOhUT5RLqUP6mmC5oc2IruMhzqNmsn0eYbgfUgiYCo7RX3hDefWtMff7+IXXz
a/Z7UTohlw2Q9DzMjp64WC3yFRMzbEhzdxW/Y1lJPpdcN9bhlIca1UqxbEAeLTAm
m983nPbKV3UQ70K57DE9xYA3lIrJKA/DfgH0mHsI1aixNdBSvr68GtzPars/Jm4f
nL/J86haN4Gw0zqDCWWK7yALNIQOWUdvha6i/Ota8xSJgIydHU+FY1uEK8ipDRfa
oHpvOuKFDgfas1lgx/nVxDP0myANGnzzNIxoUXfNzVXzLR044B7CxA2Vqb2LYWP7
3IYQAMN6OWANRHQDiKisRb8sXWsG/daq86VEetIZmROLE9smlaCp1pj4+9TRR5Dz
EFNEz+ixCrPhzY0J8XlpUqmC0yHVk2NxsUC1nDP/Cc/2b3Tmk4AYSSC1kL53WNkH
QHTBgd+Am9IQqoKNH7rTMCylviPqKK2yj+jJbpmr//rsYAIVROQ6C/KGkswWB63q
F+vTqCCyBImcF1mFcBFgqRfOV2wz5arDWYSP6bugPotE8RLeMAJqwIGV+/y1GrSb
kVV682oBOvWHzdPdk33o
=p2Bl
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_16_47_52_+1000_NRdURYob4XRbPIqC--
