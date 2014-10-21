Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaJULr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:47:59 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:61383 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaJULr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:47:57 -0400
Date: Tue, 21 Oct 2014 07:49:51 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Thermal:Remove usless if(!result) before return tz
Message-ID: <20141021114949.GA3465@developer>
References: <5444C78F.10404@huawei.com>
 <20141020121039.GA3688@developer>
 <5445D44D.60808@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <5445D44D.60808@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Yao,

On Tue, Oct 21, 2014 at 11:34:37AM +0800, Yao Dongdong wrote:
>=20
> On 2014/10/20 20:10, Eduardo Valentin wrote:
> > Hello Yao
> >
> > On Mon, Oct 20, 2014 at 04:27:59PM +0800, Yao Dongdong wrote:
> >> result is always zero when comes here.
> >>
> >> Signed-off-by:yaodongdong@huawei.com
> >>
> >> ---
> >>  drivers/thermal/thermal_core.c | 3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_=
core.c
> >> index 5b7d466..19cac8e 100644
> >> --- a/drivers/thermal/thermal_core.c
> >> +++ b/drivers/thermal/thermal_core.c
> >> @@ -1568,8 +1568,7 @@ struct thermal_zone_device *thermal_zone_device_=
register(const char *type,
> >>
> >>     thermal_zone_device_update(tz);
> >>
> >> -   if (!result)
> >> -       return tz;
> >> +   return tz;
> >>
> > Adding a return here will make the resource release below not reachable
> > in the fail path.
>=20
> But all fails above followed a "goto unregister", so i think it must be s=
uccessful when come here.

Yes, I see your point. Agreed.

Acked-by: Eduardo Valentin <edubezval@gmail.com>

>=20
> Thanks.
>=20
> >>  unregister:
> >>     release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
> >> --
> >> 1.8.0.1
> >>
> >>
>=20
>=20

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURkhTAAoJEMLUO4d9pOJWCEIH/jIFFznXr7VZtJ5rBaIciq5R
4RZnx88TOZ+AAWh9NVw84q267V8S8zMWl4x7cxkUSzxegHCH1dRzpU4b5ocXk0yR
syBQq2x6+Unh/J6VAILcF1Nx7klfbdVVbAzTxUalWLwS36Ap1yvNE2PFOxvXo8aI
CbXnmMqE4eiman1ArPQeLb1Z0oFGR4CdibuWx+Pb8uFoGUPcbxVTBupkjDslL1sd
D77V0VeTvpSx1s+S5pvcNzRiHGDx7xW3V5TZnEgEgO/bbX0uLkRPyQVIfdS91go7
D8VvilbLTLx7XOsb7POqKGH9ywHx4UbD3IoOHZgC0YlRWQSsn7Wy441016WAWUU=
=NJxK
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
