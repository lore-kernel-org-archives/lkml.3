Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbaDBKNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:13:13 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:24863
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758342AbaDBKNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:13:11 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] regmap: add DT endianness binding support.
Thread-Topic: [PATCH 2/2] regmap: add DT endianness binding support.
Thread-Index: AQHPTLiMZYVm856dlkWS6Ns2hj5veJr+Hc2w
Date: Wed, 2 Apr 2014 10:13:07 +0000
Message-ID: <db42049ab0384d9cb50a9d91ab504796@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396250797-17758-1-git-send-email-Li.Xiubo@freescale.com>
 <1396250797-17758-3-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1396250797-17758-3-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(79102001)(50986001)(81542001)(98676001)(74366001)(59766001)(77982001)(20776003)(81686001)(85852003)(74502001)(74316001)(47736001)(47446002)(83072002)(47976001)(63696002)(76786001)(80976001)(31966008)(74662001)(33646001)(2656002)(92566001)(99396002)(90146001)(94946001)(56816005)(80022001)(85306002)(76576001)(93516002)(53806001)(95416001)(93136001)(46102001)(66066001)(65816001)(95666003)(69226001)(49866001)(74876001)(97186001)(54356001)(51856001)(86362001)(99286001)(97336001)(87266001)(81342001)(81816001)(54316002)(83322001)(19580395003)(74706001)(87936001)(76482001)(94316002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:BDD0F5DD.28E34D99.73E5B770.4CA2B371.2018C;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please discard this patch series:

There has some problems about the commit message, I will resend
this patch series.



> Subject: [PATCH 2/2] regmap: add DT endianness binding support.
> 
> For many drivers which will support rich endianness of CPU<-->Dev
> need define DT properties by itself without the binding support.
> 
> The value endianness using regmap-mmio, for example:
> Index    CPU       Device     Endianess flag for DT property
> ------------------------------------------------------------
> 1        LE        LE         -
> 2        LE        BE         'little-endian'


Should be 'big-endian' here.


> 3        BE        BE         -
> 4        BE        LE         'big-endian'
> 

Should be 'little-endian' here.


> ============
> 
> Here add DT endianness binding support will define two string
> properties of the register and value endiannesses:
> 
> 'reg-endian' and 'val-endian'.
> 
> And the value of them will be:
> 'LE' : REGMAP_ENDIAN_LITTLE
> 'BE' : REGMAP_ENDIAN_BIG
> 'NT' : REGMAP_ENDIAN_NATIVE
> Absent : REGMAP_ENDIAN_DEFAULT
> 
> The value endianness using regmap-mmio, for example:
> Index    CPU       Device     Endianess flag for DT property
> ------------------------------------------------------------
> 1        LE        LE         'NT' or absent
> 2        LE        BE         'LE'

Should be 'BE' here.


> 3        BE        BE         'NT' or absent
> 4        BE        LE         'BE'
> 

Should 'LE' here.



> Please see the following documetation for detail usage:
>     Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> 

Thanks,

BRs
Xiubo


