Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaIRFIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:08:02 -0400
Received: from mail-bn1on0068.outbound.protection.outlook.com ([157.56.110.68]:24480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751212AbaIRFH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:07:59 -0400
Date: Thu, 18 Sep 2014 07:07:40 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] devicetree: cadence_ttc: Document binding for timer
 width
References: <3537996136ec435ea660da869102d0a019214979.1410964243.git.michal.simek@xilinx.com>
 <20140917161737.GA7983@leverpostej>
In-Reply-To: <20140917161737.GA7983@leverpostej>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="I6N0pA3pweUb3RretUeX63i0c81lrO6p1"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20950.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <db43281a-06bc-436b-a082-212d1f95d974@BL2FFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(199003)(51704005)(164054003)(24454002)(377454003)(479174003)(31966008)(1496007)(76176999)(54356999)(50986999)(99396002)(95666004)(102836001)(568964001)(83322001)(44976005)(19580405001)(70736001)(19580395003)(6806004)(71186001)(4396001)(21056001)(65956001)(87936001)(83072002)(85852003)(83506001)(84326002)(31696002)(86362001)(92566001)(92726001)(64706001)(20776003)(80022003)(90102001)(46102003)(81542003)(79102003)(74502003)(74662003)(65806001)(81342003)(77982003)(104016003)(512944002)(85306004)(107046002)(74316001)(76482002)(106466001)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB068;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--I6N0pA3pweUb3RretUeX63i0c81lrO6p1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/17/2014 06:17 PM, Mark Rutland wrote:
> On Wed, Sep 17, 2014 at 03:30:49PM +0100, Michal Simek wrote:
>> From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
>>
>> Modern TTC implementations can extend the timer width to 32 bit. This
>> feature is not self identifying so the driver needs to be made aware
>> via device tree.
>>
>> Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>  Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt | 4 +++=
+
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/timer/cadence,ttc-timer=
=2Etxt b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
>> index 993695c659e1..5439976eca6b 100644
>> --- a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
>> +++ b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
>> @@ -6,6 +6,9 @@ Required properties:
>>  - interrupts : A list of 3 interrupts; one per timer channel.
>>  - clocks: phandle to the source clock
>>
>> +Optional properties:
>> +- timer-width: Bit width of the timer. Either 16 or 32 (default 16).
>=20
> Are we expecting TTC implementations with widths other than 16 or 32?

IRC if you use 32bit timer and setup for example 24bit width it should wo=
rk
too and you are just ignoring that upper bits.

>=20
> This looks sane to me, but we might be able to just have a 32-bit-timer=

> property if we don't expect arbitrary widths.

Definitely model different timer width is easily possible to do in qemu
that's why I think having more generic property timer-width is just bette=
r than
having property used just for one case.

Thanks,
Michal



--I6N0pA3pweUb3RretUeX63i0c81lrO6p1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQaaKAACgkQykllyylKDCFVWgCfS1L5RGKBS39l+QPshq2fBsZn
W+YAnRKGrMh1wMN6pouINT3Dr0T+3Rxu
=5O5P
-----END PGP SIGNATURE-----

--I6N0pA3pweUb3RretUeX63i0c81lrO6p1--
