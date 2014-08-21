Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaHUHFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:05:18 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47736 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaHUHFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:05:15 -0400
Date: Thu, 21 Aug 2014 09:05:12 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        wni@nvidia.com
Subject: Re: [PATCH v2 2/5] of: Add nvidia,controller-id property to Tegra
 I2C bindings
Message-ID: <20140821070511.GF4486@ulmo>
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com>
 <1407933685-12404-3-git-send-email-mperttunen@nvidia.com>
 <53F502D7.9030403@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
Content-Disposition: inline
In-Reply-To: <53F502D7.9030403@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 02:19:35PM -0600, Stephen Warren wrote:
> On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
> >Sometimes, hardware blocks want to issue requests to devices
> >connected to I2C buses by itself. In such case, the bus the
> >target device resides on must be configured into a register.
> >For this purpose, each I2C controller has a defined ID known
> >by the hardware. Add a property for these IDs to the device tree
> >bindings, so that drivers can know what ID to write to a hardware
> >register when configuring a block that sends I2C messages autonomously.
>=20
> >diff --git a/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.tx=
t b/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt
>=20
> >+Optional properties:
> >+- nvidia,controller-id: ID of controller when referred to in
> >+                        hardware registers.
>=20
> I'd prefer to put this information into the thermal trip node, since this
> represents what ID the PMC uses to communicate with the I2C controller, a=
nd
> there's no absolute guarantee that multiple clients that communicate
> directly with an I2C controller would use the same numbering scheme.
>=20
> If that doesn't work, can be at least name this nvidia,pmc-controller-id =
or
> nvidia,id-in-pmc so that if there are different numbering schemes, there'=
s a
> clear path to represent this in different properties without conflicting
> names?

This is the ID of the controller used internally by the documentation.
And as far as I can tell every aspect of the documentation refers to the
controllers by the same ID (clocks, interrupts, ...). The PMC uses this
same numbering scheme. That makes the ID about as canonical as it gets,
so the extra prefix isn't warranted in my opinion.

I'd argue that if ever there was a case where something was referring to
the controller using a different ID then that should be considered the
oddball and get special treatment.

Thierry

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9ZonAAoJEN0jrNd/PrOhb18P/1BvBT3dl0m0F++JJ126LxXO
GfEnytQDAepqT41BX+sv7FB/LrLjrZ+whdGXgkf6PK9jX8MJ8X9ALnUp5plh7uLW
LK/x+Yq7MLHwZY11V4WYYLvYzTOypwrM7TdzoiOPCEAwgSQIy/m51q+ntuU89jf3
Y6i3VsHeW/2SJjV5mgQdugDTvCXferuoti34J2uM1DWFNa/6St/dTAGIS2ZKqvkP
O65pAz2GB1/1KmQCU4mMY+WpG+s/+j+Ob2Qic+31dlaSOXQ8pGFWVBn8hzx0Qupn
+Szy6OE19IV7knVyjxEICBCk5dhI154UxCXuV1A/+9QIqriAhXOgQLRaTLZQX9EI
DdMlN9JTQV63rV3ZUuCCTTs0fab6jqtPk29zAJoQaMiZUHK2etbKrV1Vrfyd04zU
KObZ92lR2nsnCGz7NKhbMpavqMF+ck3aFAe2y8mL3PlaH3QCw/y1RtIuD6qiiqUi
kWI+KmTQWhVrlk5JPtiAPv20gZskHQV4HnsWaVa4xzNH6Ciz7t3qZLEZzoGF3g3t
coE3xOZdhrh8c8q7Gi1CTFLMBoeJ+JP45dk/R4nrEzML1M8gz+lXzEamSwujSdtF
q+gATkjFtTqUjSxkmEueEphlbAFcf4JMu/e/pydEDUHljBYIvRWIGYQqkF6nPSmc
A1w92ngJ56icMs7LgUyE
=LEHr
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--
