Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaGWGyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:54:21 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55903 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaGWGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:54:19 -0400
Date: Wed, 23 Jul 2014 08:54:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
Message-ID: <20140723065412.GA15759@ulmo.nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
 <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
 <CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 10:14:44AM +0530, Viresh Kumar wrote:
> On 21 July 2014 21:09, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
>=20
> > diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> > index 7364a53..df3c73e 100644
> > --- a/drivers/cpufreq/Kconfig.arm
> > +++ b/drivers/cpufreq/Kconfig.arm
> > @@ -244,6 +244,7 @@ config ARM_SPEAR_CPUFREQ
> >  config ARM_TEGRA_CPUFREQ
> >         bool "TEGRA CPUFreq support"
> >         depends on ARCH_TEGRA
> > +       depends on GENERIC_CPUFREQ_CPU0
>=20
> Wouldn't this also disturb the existing cpufreq driver for earlier
> tegra platforms? i.e. we don't need cpufreq-cpu0 for them
> atleast as of now.

Perhaps this should be "select" rather than "depends on"?

> > +static int tegra124_cpufreq_probe(struct platform_device *pdev)
> > +{
> > +       int ret;
> > +
> > +       cpu_dev =3D get_cpu_device(0);
> > +       if (!cpu_dev)
> > +               return -ENODEV;
> > +
>=20
> Shouldn't we do a of_node_get() here?

I think this would need to be get_device() since it's the struct device
that's being used subsequently.

Thierry

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTz1wTAAoJEN0jrNd/PrOhkXAP/izIcV7uR89IM12bl0i4flPE
coaTpdmTakTvdjRRJdbeolp2Y6Y0L8yuYYs7/cxtcv6tPzRLwEQgDcyEp7WkmPn+
mQT4sb5WGmyNyl+q8RiSqUPV9+Wg4ConXjvvTGxA/lQ+11/y3iSSxrrwyOZ9MCB3
OFP6BlmfTqB0UpvMb+E42cI/U5qJLE1DaQVcuSUvkEj45WQdRnwiYFeF4j/Z0q7t
IIJpN+Qaxp1QqKPTH9YNeKG5USd3czwvd0rMU4Zh8+s/PeBvEly8Af1wlcI6Lxzr
IfOmDLLrWP8eMTaYmz4byc7OvJW8bcQbacGV3JoLFPtf9qw7HOZzLcOSI08K1jDb
WhyACPtIUtnCeaY2F7aq3uywOjeExJkYJQiLA1UON4o/nSd8Gbkos8eIrWL6nyyw
pHjTx+1RNBXnlKv1G0nNVDsM7s/ot2ykHwiBD1qqhr10c1b/J2/j0+RCXdNwdTF4
T0tih1pdYUUUlkQ7kSot+V6j1qEnSUnViAsl2EKsAvTR3f9L0HQnLrWbs0c8O+HL
AcchUwNMpQuqdfk1MK2PgnXcdaByF8iUB4aF7x+aLq82AJoXRgSOr4r1HHLaE9GZ
6OYFI4rcqgK4REW9mZbjKDMPPkkVw0KeIhFpSgKqbanKB/AkNmQUbYOmupXXNJqw
UPOzbD3WvUlzgUH+9hr7
=PCQZ
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
