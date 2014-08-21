Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbaHUM3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:29:02 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:30472
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753792AbaHUM26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:28:58 -0400
Date: Thu, 21 Aug 2014 14:28:48 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 9/9] ARM: zynq: Rename 'zynq_platform_cpu_die'
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408567315-28479-10-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1408567315-28479-10-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="E6jSFPjdRpPTIqJGfiSoF9FRNNWJctKVP"
X-RCIS-Action: ALLOW
Message-ID: <4ac42f4d-72bf-4a8d-a997-094f129d7c74@BN1AFFO11FD020.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(164054003)(189002)(377454003)(479174003)(199003)(24454002)(54356999)(71186001)(19580395003)(50986999)(81542001)(81342001)(107046002)(79102001)(70736001)(74316001)(44976005)(4396001)(87936001)(77982001)(86362001)(6806004)(64126003)(85306004)(95666004)(46102001)(19580405001)(99396002)(33646002)(20776003)(512944002)(85852003)(568964001)(64706001)(83506001)(31966008)(83072002)(104016003)(80022001)(65956001)(92726001)(65806001)(21056001)(106466001)(83322001)(84326002)(31696002)(92566001)(102836001)(76482001)(74662001)(74502001)(76176999)(1496007)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB061;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--E6jSFPjdRpPTIqJGfiSoF9FRNNWJctKVP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> Match the naming pattern of all other SMP ops and rename
> zynq_platform_cpu_die --> zynq_cpu_die.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/mach-zynq/platsmp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.=
c
> index 04e578718aa2..95933c5e70e1 100644
> --- a/arch/arm/mach-zynq/platsmp.c
> +++ b/arch/arm/mach-zynq/platsmp.c
> @@ -138,7 +138,7 @@ static int zynq_cpu_kill(unsigned cpu)
>   *
>   * Called with IRQs disabled
>   */
> -static void zynq_platform_cpu_die(unsigned int cpu)
> +static void zynq_cpu_die(unsigned int cpu)
>  {
>  	zynq_slcr_cpu_state_write(cpu, true);
> =20
> @@ -158,7 +158,7 @@ struct smp_operations zynq_smp_ops __initdata =3D {=

>  	.smp_boot_secondary	=3D zynq_boot_secondary,
>  	.smp_secondary_init	=3D zynq_secondary_init,
>  #ifdef CONFIG_HOTPLUG_CPU
> -	.cpu_die		=3D zynq_platform_cpu_die,
> +	.cpu_die		=3D zynq_cpu_die,
>  	.cpu_kill		=3D zynq_cpu_kill,
>  #endif
>  };

Will be good if you can move fix that kernel-doc format for this function=

too. It is just nice to have thing.

Thanks,
Michal




--E6jSFPjdRpPTIqJGfiSoF9FRNNWJctKVP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlP15gAACgkQykllyylKDCHSegCdEgP2AzxXjeYe4Yx1hOz3GR5R
RgkAmgPR5Ybaub07soh0+psJHObiejM9
=cmxL
-----END PGP SIGNATURE-----

--E6jSFPjdRpPTIqJGfiSoF9FRNNWJctKVP--
