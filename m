Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaHUQyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:54:05 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42115 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaHUQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:54:03 -0400
Date: Thu, 21 Aug 2014 18:53:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        wni@nvidia.com
Subject: Re: [PATCH v2 1/5] of: Add descriptions of thermtrip properties to
 Tegra PMC bindings
Message-ID: <20140821165357.GC1172@ulmo>
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com>
 <1407933685-12404-2-git-send-email-mperttunen@nvidia.com>
 <53F50231.5010605@wwwdotorg.org>
 <20140821065853.GE4486@ulmo>
 <53F61275.9020508@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <53F61275.9020508@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 09:38:29AM -0600, Stephen Warren wrote:
> On 08/21/2014 12:58 AM, Thierry Reding wrote:
> >On Wed, Aug 20, 2014 at 02:16:49PM -0600, Stephen Warren wrote:
> >>On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
> >>>Hardware-triggered thermal reset requires configuring the I2C
> >>>reset procedure. This configuration is read from the device tree,
> >>>so document the relevant properties in the binding documentation.
> >>
> >>>diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra2=
0-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.=
txt
> >>
> >>>+Hardware-triggered thermal reset:
> >>>+On Tegra30, Tegra114 and Tegra124, if the 'i2c-thermtrip' subnode exi=
sts,
> >>>+hardware-triggered thermal reset will be enabled.
> >>
> >>"will be enabled" sounds like SW behaviour, whereas DT is suppose to
> >>describe HW, and leave SW to define its own behaviour. I would suggest:
> >>
> >>Optional sub-nodes:
> >>i2c-thermtrip: Describes how to power off the system in the event of a
> >>   thermal emergency.
> >>
> >>>+Required properties for hardware-triggered thermal reset (inside 'i2c=
-thermtrip'):
> >>
> >>Simpler might be:
> >>
> >>Required properties for i2c-thermtrip node:
> >>
> >>>+- nvidia,pmu : Phandle to power management unit / PMIC handling power=
off
> >>>+- nvidia,reg-addr : I2C register address to write poweroff command to
> >>>+- nvidia,reg-data : Poweroff command to write to PMU
> >>
> >>Why are both the PMU/PMIC phandle and the register address/data require=
d? I
> >>thought the purpose of having the phandle was to allow the register add=
ress
> >>and data to be queried from the PMU/PMIC driver.
> >>
> >>To me, it seems much simpler to get rid of the phandle and just hard-co=
de
> >>the I2C bus number, address, and data into this node, rather than havin=
g to
> >>go query it from the PMU/PMIC driver, then find the I2C controller, then
> >>query it for its ID (and hope that all HW modules that talk to I2C
> >>controllers directly use the same numbering scheme...)
> >
> >I originally requested this to be changed. It seems wrong to duplicate
> >information about the PMIC in both the PMIC device tree node and the
> >i2c-thermtrip node if we can get the same information from the driver
> >directly (via the phandle). It certainly requires a little more code,
> >but at the advantage of not having to figure out the I2C controller
> >hardware number and I2C slave addresses when writing the i2c-thermtrip
> >node.
>=20
> I cant see that argument, but surely the PMIC driver can also supply the
> "reg-addr" and "reg-data" values too, if it's already being queried for t=
he
> I2C device address and bus number? The binding above appears to duplicate
> part of the information, while requiring querying of the other part.

I suppose that could be done. It would take a new function to do that,
though, since I'm not aware of a generic mechanism to query this kind of
information from a PMIC (there's no generic PMIC API, either, so perhaps
it would be a good time to create one?). The I2C controller and I2C
slave are generic I2C properties, whereas the register and data to power
off the device are very device specific.

Thierry

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9iQlAAoJEN0jrNd/PrOhDrMQAK+P2klWFNegkLWLP7HHKFaZ
ROp/3zfVJwUYNlLNNAq3i9wKou2aym2IFz08I9pjjCzaFA5Z0ITzx+2ZCstJx4Px
CI7M2f1wJSSL3mcwEwmhETLdb+505Il+62D1bw8z7j5HaYk3ylUX/KLfVpdFESI/
8TCiRZYAU8/4xguAkxFxqX0Fcrvt9erd58uVA2Jw7+bSFrtND9gOPM12htqgUVdK
zDMFZaTj8tr51ALxMIfZ4KC7fFPCiHbdssmW6Mu7MtPNWcnqB7T/juG12q6aIaYZ
lV9yeqdRjNCfyFyIPmhfVEic3oTMRa+cdDNprDu0Ycg84JffI7iG86R8NbLUboXg
7EJwZjFUvlanlHB0x0eGDmXMHbZDnFJYr1mC9qpiqxje7o58af8/CoojDQ8t/5Ch
/6e2NnRMWU5sogwqujdF59I6x/Z8+5ZlgSlZ4DL+dna/dxvVAPTdYg7njr04iA4Z
eNlP+06xzyLbxveyRjdP2CeGflat4ucOoQEoNR6KqDjuHKgngr1llkOXtQlYTSKN
UuJPFQEGYgD7DsBk//2/EHYWcwjjFL0MI52cr/oj3bCwfl3zCdkzRynGCTv1kcF/
+96hldRG3iiAYjrNTXimMgA6LA5Ab4eZxpI5n+0VcSNW7RNDM+iKx+by9Kh/KC1L
IG/TWdDVuntu9Qf/EmSx
=GjaV
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
