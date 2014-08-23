Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaHWAbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:31:42 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:36665
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752476AbaHWAbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:31:41 -0400
Date: Fri, 22 Aug 2014 19:31:12 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@shineypoop
To: Mark Brown <broonie@kernel.org>
CC: <linux@roeck-us.net>, <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 1/2] pmbus: add regulator support
In-Reply-To: <20140822214417.GC24407@sirena.org.uk>
Message-ID: <alpine.DEB.2.10.1408221927370.2334@shineypoop>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com> <1408741894-24879-2-git-send-email-atull@opensource.altera.com> <20140822214417.GC24407@sirena.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [24.206.110.125]
X-ClientProxiedBy: BLUPR01CA045.prod.exchangelabs.com (25.160.23.35) To
 BL2PR03MB306.namprd03.prod.outlook.com (10.141.68.14)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(24454002)(189002)(51914003)(51704005)(199003)(47776003)(50466002)(64706001)(21056001)(42186005)(23726002)(4396001)(102836001)(46102001)(77982001)(76482001)(74662001)(74502001)(86152002)(77096002)(19580405001)(33716001)(66066001)(31966008)(101416001)(81342001)(85306004)(95666004)(105586002)(87976001)(83506001)(92566001)(79102001)(19580395003)(92726001)(81542001)(50986999)(20776003)(83072002)(46406003)(54356999)(110136001)(106356001)(85852003)(83322001)(107046002)(99396002)(90102001)(86362001)(76176999)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB306;H:shineypoop.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Mark Brown wrote:

> On Fri, Aug 22, 2014 at 04:11:33PM -0500, atull@opensource.altera.com wrote:
> 
> > +	if (pdata && pdata->reg_init_data) {
> > +		config.init_data = pdata->reg_init_data;
> > +	} else {
> > +		config.init_data = of_get_regulator_init_data(dev, np);
> > +		if (!config.init_data)
> > +			return -ENOMEM;
> > +	}
> 
> It should be fine to start with no init data - just let the regulator
> core worry about it.  This will allow users to read back the state even
> if they can't change anything which is useful for system bringup or
> general debugging.
> 

of_get_regulator_init_data() will only have an error if it cannot alloc 
the regulator_init_data struct.  That's why I did -ENOMEM.  If there
is no platform data and nothing about the regulator in the device tree, we 
should end up with a zeroed out regulator_init_data.

Thanks for the review.

Alan
