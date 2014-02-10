Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaBJPl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:41:57 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:20865
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751744AbaBJPly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:41:54 -0500
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2014 10:41:54 EST
Message-ID: <1392045915.30419.6.camel@e37108.spectralink.com>
Subject: Re: [PATCH] dp83640: Get gpio and master/slave configuration from DT
From: Stefan =?ISO-8859-1?Q?S=F8rensen?= 
	<stefan.sorensen@spectralink.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Mon, 10 Feb 2014 16:25:15 +0100
In-Reply-To: <20140210134237.GF29080@e106331-lin.cambridge.arm.com>
References: <1392037240-30913-1-git-send-email-stefan.sorensen@spectralink.com>
	 <20140210134237.GF29080@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.83.164.162]
X-ClientProxiedBy: DB3PR01CA002.eurprd01.prod.exchangelabs.com
 (10.255.177.19) To DM2PR07MB334.namprd07.prod.outlook.com (10.141.98.12)
X-Forefront-PRVS: 0118CD8765
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(24454002)(377424004)(199002)(189002)(51704005)(74662001)(85306002)(65816001)(81342001)(81542001)(50466002)(93136001)(74502001)(89996001)(74876001)(51856001)(90146001)(56816005)(66066001)(86362001)(47446002)(80022001)(69226001)(74706001)(31966008)(88136002)(95416001)(46102001)(93516002)(33646001)(62966002)(74366001)(80976001)(83322001)(23676002)(81686001)(92566001)(56776001)(54316002)(87266001)(87286001)(92726001)(50226001)(4396001)(81816001)(94316002)(63696002)(76796001)(77156001)(76786001)(53806001)(77096001)(47736001)(85852003)(47776003)(93916002)(47976001)(50986001)(49866001)(42186004)(94946001)(83072002)(59766001)(87976001)(77982001)(76482001)(79102001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB334;H:[172.29.194.63];CLIP:213.83.164.162;FPR:20D7D094.AD3B0F0B.43E49B72.46D5CA01.20202;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: spectralink.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 13:42 +0000, Mark Rutland wrote:

> Binding document please.

Dang, I somehow managed to drop that from the patch. I will fix for the
next version.

> > +	if (of_find_property(node, "dp83640,slave", NULL))
> > +		dp83640->slave = true;
> 
> Use of_property_read_bool.

Fixed.

> > +	prop = of_find_property(node, "dp83640,perout-gpios", &proplen);
> > +	if (prop) {
> > +		if (dp83640->slave) {
> > +			pr_err("dp83640,perout-gpios property can not be set together with dp83640,slave");
> > +			return -EINVAL;
> > +		}
> > +
> > +		clock->caps.n_per_out = proplen / sizeof(u32);
> > +		if (clock->caps.n_per_out > N_EXT) {
> > +			pr_err("dp83640,perout-gpios may not have more than %d entries",
> > +			       N_EXT);
> > +			return -EINVAL;
> > +		}
> > +		err = of_property_read_u32_array(node, "dp83640,perout-gpios",
> > +						 clock->perout_gpios,
> > +						 clock->caps.n_per_out);
> > +		if (err < 0)
> > +			return err;
> > +	}
> 
> This looks nothing like the standard gpio bindings. What _exactly_ is
> this property describing?

The dp83640 has a number of pins of which 8 of them can be used for
either timestamping events or triggering changes at programmed
intervals. These properties are used to configure which pins get
assigned to what function.

> If this is not using the standard gpio bindings then this should be
> renamed.

Maybe a gpio->pin renaming?

Stefan

