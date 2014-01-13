Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaAMGPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:15:44 -0500
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:7243
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751220AbaAMGPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:15:41 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: fsl-sai: Add device tree nodes and its availiable
 check
Thread-Topic: [PATCH] ASoC: fsl-sai: Add device tree nodes and its
 availiable check
Thread-Index: AQHPDbBgYX3a01s9p0am5sF4U50z3pp9zVkAgAQlirA=
Date: Mon, 13 Jan 2014 06:15:24 +0000
Message-ID: <8ea36054cbe745cf9ce5c5d4a786f9ff@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389319550-12238-1-git-send-email-Li.Xiubo@freescale.com>
 <20140110110900.GC29039@sirena.org.uk>
In-Reply-To: <20140110110900.GC29039@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(51704005)(199002)(189002)(83072002)(85852003)(56816005)(51856001)(87266001)(87936001)(76796001)(93136001)(2656002)(33646001)(74502001)(74366001)(31966008)(80022001)(54316002)(47446002)(65816001)(74662001)(76482001)(63696002)(66066001)(74706001)(90146001)(74316001)(54356001)(46102001)(74876001)(83322001)(53806001)(69226001)(56776001)(4396001)(81816001)(79102001)(59766001)(92566001)(76786001)(76576001)(49866001)(80976001)(81686001)(77982001)(47976001)(47736001)(81342001)(50986001)(85306002)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +	if (!np || !of_device_is_available(np))
> > +		return -ENODEV;
> > +
> 
> I would expect the of_device_is_available() check to be done by the
> driver core rather than by individual drivers - every single driver
> should have that check.  Is this not happening?  The check for np is OK
> though.

Yes, I hasn't found the core driver does that for now...

And IMO this is needed since the SAI driver is only base dts. And maybe
the device is not presently operational, but it might become operational
in the future (for example, something is not plugged in, or switched off).
Or A serious error was detected in the device, and it is unlikely to become
operational without repair...

And for now for the individual drivers, before calling the of_device_is_available
the '!np' check is need, because:
While in __of_device_is_available:
 >	status = of_get_property(device, "status", &statlen);
 >	if (status == NULL)
 >		return 1;
The status value returned from 'of_get_property()' will be NULL in two cases:
Firstly: the 'device' value (device node) is NULL.
Secondly: the 'status' property is actaully not exist.

If the device node is NULL, the __of_device_is_available will return true too,
that will mean the absent state of the 'status' property.


Thanks,

--
Best Regards,
Xiubo
