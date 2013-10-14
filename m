Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab3JNJFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:05:08 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:59138 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3JNJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:05:05 -0400
Message-ID: <525BB3B7.7000802@monstr.eu>
Date: Mon, 14 Oct 2013 11:04:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] clk/zynq/clkc: Add 'fclk-enable' feature
References: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="dEccllHRKSxu9DdNso9tRnDA2bEFqAE0o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dEccllHRKSxu9DdNso9tRnDA2bEFqAE0o
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/10/2013 07:10 PM, Soren Brinkmann wrote:
> In some use cases Zynq's FPGA clocks are used as static clock
> generators for IP in the FPGA part of the SOC for which no Linux driver=

> exists and would control those clocks. To avoid automatic
> gating of these clocks in such cases a new property - fclk-enable - is
> added to the clock controller's DT description to accomodate such use
> cases. It's value is a bitmask, where a set bit results in enabling
> the corresponding FCLK through the clkc.
>=20
> FPGA clocks are handled following the rules below:
>=20
> If an FCLK is not enabled by bootloaders, that FCLK will be disabled in=

> Linux. Drivers can enable and control it through the CCF as usual.
>=20
> If an FCLK is enabled by bootloaders AND the corresponding bit in the
> 'fclk-enable' DT property is set, that FCLK will be enabled by the clkc=
,
> resulting in an off by one reference count for that clock. Ensuring it
> will always be running.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v2:
>  - change default value for fclk-enable to '0'
> ---
>  Documentation/devicetree/bindings/clock/zynq-7000.txt |  4 ++++
>  drivers/clk/zynq/clkc.c                               | 18 +++++++++++=
++++---
>  2 files changed, 19 insertions(+), 3 deletions(-)

For both patches:
Acked-by: Michal Simek <michal.simek@xilinx.com>

Mike: Can you please add both these patches to your tree?
There shouldn't be any conflict with DT patch itself.
But if you don't want to add 2/2 through your tree, I am also fine
with taking this through my zynq tree.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--dEccllHRKSxu9DdNso9tRnDA2bEFqAE0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJbs7wACgkQykllyylKDCHTiwCeJf5wDat0vQWyAjf5hzSOugtX
EzMAoIOjtlrHrMFEVzGRYyAxd4mkSFYB
=n4gz
-----END PGP SIGNATURE-----

--dEccllHRKSxu9DdNso9tRnDA2bEFqAE0o--
