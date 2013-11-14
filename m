Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3KNUCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:02:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3KNUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:02:44 -0500
Date: Thu, 14 Nov 2013 12:02:34 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: ecryptfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] ecryptfs: Fix explicit null dereference
Message-ID: <20131114200234.GB7693@boyd>
References: <1384454534-27807-1-git-send-email-geyslan@gmail.com>
 <20131114195238.GA7693@boyd>
 <CAGG-pURhr-YkQT5xLefK0=uN7vNx_EGJob=w54Z7VzcjYb=qiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <CAGG-pURhr-YkQT5xLefK0=uN7vNx_EGJob=w54Z7VzcjYb=qiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-11-14 17:58:40, Geyslan Greg=F3rio Bem wrote:
> 2013/11/14 Tyler Hicks <tyhicks@canonical.com>:
> > On 2013-11-14 15:42:14, Geyslan G. Bem wrote:
> >> If the condition 'ecryptfs_file_to_private(file)' takes false branch
> >> lower_file is dereferenced when NULL.
> >>
> >> Caught by Coverity: CIDs 1128834 and 1128833.
> >>
> >> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> >> ---
> >
> > Hello - Smatch picked up on this earlier in week and Dan analyzed the
> > situation here:
> >
> >   http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/441
> >
> > I agree with his assessment and proposed the following patch:
> >
> >   http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/442
> >
> > It makes Smatch happy and it should also make Coverity happy.
> >
> > Tyler
>=20
> True. Disregard mine.
>=20
> Thanks Tyler.

Thank you! Can I add your Reviewed-by: tag to that patch prior to
pushing it to my next branch?

Tyler

>=20
> >
> >>  fs/ecryptfs/file.c | 12 ++++++++----
> >>  1 file changed, 8 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> >> index 2229a74..1c0403a 100644
> >> --- a/fs/ecryptfs/file.c
> >> +++ b/fs/ecryptfs/file.c
> >> @@ -316,10 +316,12 @@ ecryptfs_unlocked_ioctl(struct file *file, unsig=
ned int cmd, unsigned long arg)
> >>       struct file *lower_file =3D NULL;
> >>       long rc =3D -ENOTTY;
> >>
> >> -     if (ecryptfs_file_to_private(file))
> >> -             lower_file =3D ecryptfs_file_to_lower(file);
> >> +     if (!ecryptfs_file_to_private(file))
> >> +             goto out;
> >> +     lower_file =3D ecryptfs_file_to_lower(file);
> >>       if (lower_file->f_op->unlocked_ioctl)
> >>               rc =3D lower_file->f_op->unlocked_ioctl(lower_file, cmd,=
 arg);
> >> +out:
> >>       return rc;
> >>  }
> >>
> >> @@ -330,10 +332,12 @@ ecryptfs_compat_ioctl(struct file *file, unsigne=
d int cmd, unsigned long arg)
> >>       struct file *lower_file =3D NULL;
> >>       long rc =3D -ENOIOCTLCMD;
> >>
> >> -     if (ecryptfs_file_to_private(file))
> >> -             lower_file =3D ecryptfs_file_to_lower(file);
> >> +     if (!ecryptfs_file_to_private(file))
> >> +             goto out;
> >> +     lower_file =3D ecryptfs_file_to_lower(file);
> >>       if (lower_file->f_op && lower_file->f_op->compat_ioctl)
> >>               rc =3D lower_file->f_op->compat_ioctl(lower_file, cmd, a=
rg);
> >> +out:
> >>       return rc;
> >>  }
> >>  #endif
> >> --
> >> 1.8.4.2
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
> --=20
> Regards,
>=20
> Geyslan G. Bem
> hackingbits.com
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJShSxaAAoJENaSAD2qAscK4ukP/0+uukWFe7gH/e47sIbd5cdj
73inWZLDN87JJaTtOHZCwXzfvo7ib5RvK26CaXWeUPSvcSPNpI0tfPNVVtnNPiKi
DKRSaGqCnyk/PDQkrDEKt2eLlQKrPsMQgahtNwRI7PzJ7MpaFO5KjwpppRK4ojcP
Enax0XmnlMeOQZvHLpRGk6GGzuDnBpMlmLkWIZ5u660Xte5Z2/Qjxieoiwglparg
5rP5AyOP7wIQiHsRYQcNK9vBe17sq4bOjCt6PU80u/WyVDOrDQxU+LOzAbJouQry
nLqomS49e8Gat0Gywqf35PKfbHg6usvNbQh2PWb4ymjIiBKKy55cJTNMounE8HkS
Mz25R6zDM5PMZZwBqdftrUKYU3ut1miaimKq+QiPfhIlM69dMOSLNwqU1SXsm3AI
m9507fXSOMhAihy+gQD6iqk0+c6bUOPa+dJA7Q0S+sBqcuuwFanKaCERg9oAwywE
gaj8Vt19GpeRFL7PlqxkLxlIf86/grwnmZzDxdBAoEPPlqmSp9tuuC2WbJZvgAyc
vjNKbPwvvuNMvX+PNduapHfAg0YXyD5cp5F2Tie17HBwanBG2f6Fcwdd82Gll+ev
uTmQB1HtRxeaoFeLUt2ba54dl5yOH9flD4mtQCVR0qHEEPhaCvZqroVxxJVMGdmC
lEwanIFsE67bo7QhjdD6
=/IkC
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
