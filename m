Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaHDVxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:53:09 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:14146
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752131AbaHDVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:53:07 -0400
Message-ID: <1407189176.10311.12.camel@snotra.buserror.net>
Subject: Re: spi, spi_fsl-spi.c not working?
From: Scott Wood <scottwood@freescale.com>
To: <hs@denx.de>
CC: <linuxppc-dev@lists.ozlabs.org>, Andreas Larsson <andreas@gaisler.com>,
        <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "Anton Vorontsov" <avorontsov@ru.mvista.com>
Date: Mon, 4 Aug 2014 16:52:56 -0500
In-Reply-To: <53C79351.2080406@denx.de>
References: <53C79351.2080406@denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:131:b123:c54:d1b1]
X-ClientProxiedBy: DM2PR04CA026.namprd04.prod.outlook.com (10.141.154.144) To
 BN1PR0301MB0724.namprd03.prod.outlook.com (25.160.78.143)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(189002)(199002)(51704005)(377424004)(24454002)(53754006)(93916002)(101416001)(87286001)(77982001)(79102001)(87976001)(42186005)(83072002)(92566001)(85852003)(21056001)(92726001)(31966008)(86362001)(77096002)(104166001)(50466002)(103116003)(33646002)(83322001)(64706001)(77156001)(89996001)(19580405001)(47776003)(102836001)(50986999)(23676002)(76482001)(95666004)(105586002)(81542001)(74662001)(88136002)(80022001)(46102001)(110136001)(106356001)(19580395003)(74502001)(20776003)(76176999)(99396002)(107046002)(4396001)(85306004)(62966002)(50226001)(2351001)(81342001)(99106002)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0724;H:[IPv6:2601:2:5800:3f7:131:b123:c54:d1b1];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 11:11 +0200, Heiko Schocher wrote:
> Hello all,
> 
> I just tried a mpc83xx based board (similiar to the mpc8313erdb)
> with linux v3.16-rc4 using the drivers/spi/spi-fsl-spi.c driver.
> DT nodes for spi are the same as in arch/powerpc/boot/dts/mpc8313erdb.dts:
> 
>                  spi@7000 {
>                          cell-index = <0>;
>                          compatible = "fsl,spi";
>                          reg = <0x7000 0x1000>;
>                          interrupts = <16 0x8>;
>                          interrupt-parent = <&ipic>;
>                          mode = "cpu";
>                  };
> 
> Bootlog shows:
> 
> [    1.341411] fsl_spi f0007000.spi: master is unqueued, this is deprecated
> [    1.554405] ------------[ cut here ]------------
> [    1.559080] WARNING: at c023a958 [verbose debug info unavailable]

If you haven't already resolved this, could you enable verbose debug
info (or use gdb) to get the line number?

I don't see the WARNING when booting mpc8379rdb with SPI enabled (though
I do see the "master is unqueued" message).  I don't have easy access to
an mpc8313erdb to test on.

-Scott


