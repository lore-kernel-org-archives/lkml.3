Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaIOOHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:07:22 -0400
Received: from mail-bn1on0073.outbound.protection.outlook.com ([157.56.110.73]:36352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751847AbaIOOHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:07:20 -0400
X-Greylist: delayed 1960 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 10:07:19 EDT
Date: Mon, 15 Sep 2014 15:34:03 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 0/9] Zynq PM updates
References: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="NRtvChqGG5AqXXHMGgl3D1hSoloED7ESS"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20950.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <c64f6993-2f83-455e-b542-4c78eb39906f@BL2FFO11FD031.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(51704005)(24454002)(479174003)(189002)(377454003)(53754006)(199003)(19580395003)(6806004)(568964001)(83506001)(79102001)(46102001)(74662001)(21056001)(74502001)(84326002)(80022001)(92726001)(77982001)(64706001)(76482001)(86362001)(512874002)(1496007)(44976005)(83322001)(85306004)(90102001)(70736001)(85852003)(92566001)(31696002)(81542001)(54356999)(65956001)(31966008)(76176999)(95666004)(81342001)(71186001)(99396002)(102836001)(104016003)(74316001)(83072002)(20776003)(87936001)(65806001)(50986999)(4396001)(107046002)(64126003)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB053;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NRtvChqGG5AqXXHMGgl3D1hSoloED7ESS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/02/2014 11:19 PM, Soren Brinkmann wrote:
> Hi all,
>=20
> here is v2 of this series. It's mostly the same and most changes are
> related to reformatting comments. The only functional change is in 'ARM=
:
> zynq: PM: Enable DDR clock stop' which does no longer enable
> self-refresh too. It seems self-refresh is inflicting a non-negligible
> amount of latency that degrades memory performance if enabled throughou=
t
> the whole run time.
>=20
> 	Thanks,
> 	S=C3=B6ren
>=20
> Daniel Lezcano (2):
>   ARM: zynq: Remove invalidate cache for cpu die
>   ARM: zynq: cpuidle: Remove pointless code
>=20
> Soren Brinkmann (7):
>   ARM: zynq: PM: Enable A9 internal clock gating feature
>   Documentation: devicetree: Add binding for Synopsys DDR controller
>   ARM: zynq: DT: Add DDRC node
>   ARM: zynq: PM: Enable DDR clock stop
>   ARM: zynq: Synchronise zynq_cpu_die/kill
>   ARM: zynq: Remove hotplug.c
>   ARM: zynq: Rename 'zynq_platform_cpu_die'
>=20
>  .../bindings/memory-controllers/synopsys.txt       | 11 +++
>  arch/arm/boot/dts/zynq-7000.dtsi                   |  5 ++
>  arch/arm/mach-zynq/Makefile                        |  3 +-
>  arch/arm/mach-zynq/common.c                        |  7 ++
>  arch/arm/mach-zynq/common.h                        | 16 ++++-
>  arch/arm/mach-zynq/hotplug.c                       | 47 +-----------
>  arch/arm/mach-zynq/platsmp.c                       | 41 ++++++++++-
>  arch/arm/mach-zynq/pm.c                            | 83 ++++++++++++++=
++++++++
>  arch/arm/mach-zynq/slcr.c                          | 43 ++++++++++-
>  drivers/cpuidle/cpuidle-zynq.c                     | 10 +--
>  10 files changed, 205 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/memory-controller=
s/synopsys.txt
>  create mode 100644 arch/arm/mach-zynq/pm.c
>=20

Applied all.

Thanks,
Michal



--NRtvChqGG5AqXXHMGgl3D1hSoloED7ESS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQW6ssACgkQykllyylKDCH8uwCfYTkclAGg0jSyTwxbldhDXviI
R38An0/9Rvt6HERzQWZzwl5BBhtkwgiS
=UcOf
-----END PGP SIGNATURE-----

--NRtvChqGG5AqXXHMGgl3D1hSoloED7ESS--
