Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3FGGi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:38:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50367 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab3FGGi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:38:26 -0400
Message-ID: <1370587103.4149.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 185/184] [SCSI] mpt2sas: Send default descriptor for RAID
 pass through in mpt2ctl
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Moritz Muehlenhoff <jmm@inutil.org>
Date: Fri, 07 Jun 2013 07:38:23 +0100
In-Reply-To: <20130605094227.GA27324@1wt.eu>
References: <58df134a4b98edf5b0073e2e1e988fe6@local>
	 <20130604172137.930866926@1wt.eu> <20130605094227.GA27324@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bNtmsYiVoa/Ci+YYKocM"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bNtmsYiVoa/Ci+YYKocM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-06-05 at 11:42 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
> Thanks to Moritz for spotting this missing patch from the series.
>=20
> ------------------
>=20
> From: "Kashyap, Desai" <kashyap.desai@lsi.com>

commit ebda4d38df542e1ff4747c4daadfc7da250b4fa6 upstream.

> RAID_SCSI_IO_PASSTHROUGH: Driver needs to be sending the default
> descriptor for RAID Passthru, currently its sending SCSI_IO descriptor.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mp=
t2sas_ctl.c
> index ddaa99c..d88e975 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> @@ -744,8 +744,11 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
>  		    mpt2sas_base_get_sense_buffer_dma(ioc, smid);
>  		priv_sense =3D mpt2sas_base_get_sense_buffer(ioc, smid);
>  		memset(priv_sense, 0, SCSI_SENSE_BUFFERSIZE);
> -		mpt2sas_base_put_smid_scsi_io(ioc, smid,
> -		    le16_to_cpu(mpi_request->FunctionDependent1));
> +		if (mpi_request->Function =3D=3D MPI2_FUNCTION_SCSI_IO_REQUEST)
> +			mpt2sas_base_put_smid_scsi_io(ioc, smid,
> +			    le16_to_cpu(mpi_request->FunctionDependent1));
> +		else
> +			mpt2sas_base_put_smid_default(ioc, smid);
>  		break;
>  	}
>  	case MPI2_FUNCTION_SCSI_TASK_MGMT:

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-bNtmsYiVoa/Ci+YYKocM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUAUbF/3+e/yOyVhhEJAQpZ8w/3Riuon7V7TqhgOy1ZuwQQ1LpQOwU8dAQ7
JMrQrsCRndp7jdlcEIqttXkb7DWgw65eRZq2AVXsGzdBeDzy5D7eatzWw3qiHzAv
YlebfIMdKRxzBnuncuoLlqFSZ3/xUJ9FjsHN6Ng1KA8Gs4ibCjQZtr6GZ3pf9Ea2
Za1sfjlgn51YlJTaaIM+IkgwLICWxe/BRRPVJBShbQ6aFNeAVOHxawBocpV7kTDY
VoRg4A97P5YLSe+qN24vZAIjnjzoO1wd/KNbq8wCI1tsl3M/Y1508444c1BA5St5
c+2LP6Ny+t57FR/qpAayMgqiOy/+hlYpLPGwlqKcytiKDxdBrvIOY+AmIR6Y7WEo
qwMutybeWH8Kgiqzub+lPPGKMtBbgPOrKFvs8bw9nyWKMqzPMvm3eQ4gfjuJdwj2
9cSQm9WXtVGGCzF0mWW+pwspyoIX1HS23diywKYYKDRuNkjtKtvTAiwGkrtauULo
51y3zqCUPYamU0PzO4jA8+dBio6VoiRTUoPJJNHu3SnODEAFjAiVNSYTYmsStNBM
pZ10s0v1umV/b+ouYbCWhXkJAU6hAYP3FFW0BsaZa55oq8t4im9SfYAP9KQd7m+h
9z3FYTyRH+QJ0cj4sgxhhc1ax4NyiKywe743rgvxnr0N1kGRF8q33GUN86PiYvSM
X7AqMVOPUg==
=Aeb7
-----END PGP SIGNATURE-----

--=-bNtmsYiVoa/Ci+YYKocM--
