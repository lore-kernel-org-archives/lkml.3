Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3HSUKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:10:48 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:55643 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3HSUKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:10:47 -0400
Date: Mon, 19 Aug 2013 22:10:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130819201042.GB5191@mithrandir>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
 <20130816210637.GC2198@kroah.com>
 <20130816215530.GA14464@mithrandir>
 <20130816220807.GA6848@kroah.com>
 <20130817111747.GB1536@mithrandir>
 <5212757F.2080107@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <5212757F.2080107@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 01:43:59PM -0600, Stephen Warren wrote:
> On 08/17/2013 05:17 AM, Thierry Reding wrote:
> ...
> > Well, the most obvious cases where early initialization is needed
> > are interrupt controllers and clocks.
>=20
> ... and IOMMUs, which apparently need to initialize before any devices
> whose transactions are routed through the IOMMU, in order to set
> themselves up as the IOMMU for the relevant devices.
>=20
> It's possible that the CPU-visible bus structure isn't a strict
> inverse/reverse of the device-visible bus-structure. A device may have
> CPU-visible registers on one bus segment, but inject master
> transactions onto an unrelated bus segment. So it may not be as simple
> as making a bus driver for the bus segment affected by the IOMMU, and
> having that driver trigger instantiation of all its children.

Well, perhaps that can be handled via deferred probing? The only thing
preventing that right now is that drivers aren't actively aware of the
IOMMUs existence. If we can make it a requirement that each driver
needing the services of an IOMMU actively requests that service, then
deferred probing should be able to deal with it.

That doesn't necessarily mean that drivers need to be doing it manually.
It strikes me as the kind of thing that could easily be done by the
core. In fact I've been thinking of doing something similar to resolve
devicetree IRQ references at probe time, rather than at device creation
time to remove the need for interrupt chips to register early.

Thierry

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEnvCAAoJEN0jrNd/PrOhx6sP/i5FSrqgy3YdWLhdwy0AMNye
MQ32TX1AdfrmcyBCiOgFQLg48BC/Ig8Si0I5HUe8emKlaB8pXbmkfo8IJ//OEqA7
uwJuVoggE+Nqxyl/ycWOohQQexacBJH1ry7SBT32q2zyDJhHxk3PFnpV3SR8Wicx
ByyXk1w/LG9ghD8xLERGfrTk7fUF/6GTntj1KpN3Jnbo20jXwGFv1+RxXB19IDgc
HKB4QI6LJvC8+PPb9Osk0im76bHYE9blHKmwCMVba21dzloakfWlM47ti0MAuuMD
fhncKj1Nt/cm1CovKy+ENrDttkkcCHib/5R7P9EU4xPAriGCMcNX5SmQiGvov47J
El1SYcQa0q+3WMPEbnKcqhxvDGLvy1L4FpOdV/wqs7myEllJ2JSDdvwe79CwxXRf
KMAd7wOv7/CLrDuBlUEwNfp4WxNC1KThFe05Nzqq9r9Aqmd/gJcYDrvJKuoS9I8R
BQvWVI2fco2LDY9GnMZAw/X2oZvp2HKFcy57AZEstAMmm51VWvwGgwBObl/l5Ze1
lky3ydmWlBVcoQVVnUBE20Nf1BHWbtTw7ETlfVcfj+ZzUm5ZKfioe/4d4MBLGun/
YFaFIPh5uOomhAsp6N0vDWFlgKSVFZX78WIUuHVh8If98dYlTUlJd2UjYbEXjxkW
QQM2EwJPL1RLi1OkI4RX
=AQID
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
