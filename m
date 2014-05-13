Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbaEMHEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:04:47 -0400
Received: from mail-by2on0070.outbound.protection.outlook.com ([207.46.100.70]:26034
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751043AbaEMHEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:04:46 -0400
X-Greylist: delayed 1026 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2014 03:04:46 EDT
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 0/4] FTM PWM adds regmap and endianness support.
Thread-Topic: [PATCHv2 0/4] FTM PWM adds regmap and endianness support.
Thread-Index: AQHPY2INKfPXqugmK0eUOUU2T0BKJps+I06A
Date: Tue, 13 May 2014 06:32:25 +0000
Message-ID: <6abc1298f24d45b1b126f48527299f52@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398742429-10399-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1398742429-10399-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0210479ED8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(13464003)(51704005)(377454003)(21056001)(80022001)(20776003)(86362001)(81342001)(85852003)(92566001)(101416001)(2201001)(79102001)(77982001)(83072002)(2656002)(64706001)(46102001)(87936001)(33646001)(76176999)(54356999)(77096999)(4396001)(50986999)(74502001)(31966008)(74662001)(76482001)(19580405001)(81542001)(99286001)(19580395003)(83322001)(74316001)(76576001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

Ping:)



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Tuesday, April 29, 2014 11:34 AM
> To: thierry.reding@gmail.com; linux-pwm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv2 0/4] FTM PWM adds regmap and endianness support.
> 
> Convert to direct regmap API usage. Since the regmap core has already
> support rich endianness modes of device, this patch convert to direct
> regmap API usage, preparing to support big endianness for LS1 SoC.
> 
> Using the regmag framework will be more easy to support the endiannesses
> switching of one same device driver on different SoCs.
> 
> The endianness scenarios are:
> SoC     |  CPU   | FTM-PWM | 'big-endian' property is needed?
> --------|--------|---------|---------------------------------
> Vybird  |  LE    |   LE    |     No
> LS1     |  LE    |   BE    |     Yes
> LS2     |  LE    |   LE    |     No
> 
> 
> 
> Changes in V2:
> - Adds detail descriptions of these patches.
> 
> 
> Xiubo Li (4):
>   Documentation: Add 'big-endian' property for FTM PWM.
>   pwm: ftm-pwm: Clean up the code.
>   pwm: ftm-pwm: Convert to direct regmap API usage.
>   pwm: ftm-pwm: Add big-endian support
> 
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 12 ++-
>  drivers/pwm/pwm-fsl-ftm.c                          | 96 ++++++++++++---------
> -
>  2 files changed, 64 insertions(+), 44 deletions(-)
> 
> --
> 1.8.4

