Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaJPSrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:47:13 -0400
Received: from mail-bn1on0069.outbound.protection.outlook.com ([157.56.110.69]:56320
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751309AbaJPSrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:47:11 -0400
Date: Thu, 16 Oct 2014 13:40:23 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v6 3/4] pmbus: add regulator support
In-Reply-To: <20141016183501.GA21253@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1410161339450.28663@atx-linux-37>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com> <1413399310-19277-4-git-send-email-atull@opensource.altera.com> <20141016183501.GA21253@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR02CA0039.eurprd02.prod.outlook.com (10.242.225.167) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(199003)(24454002)(164054003)(99396003)(40100003)(54356999)(50986999)(53416004)(120916001)(122386002)(83506001)(42186005)(76176999)(46102003)(107046002)(80022003)(69596002)(85852003)(19580405001)(87976001)(19580395003)(105586002)(81156004)(85306004)(106356001)(66066001)(92726001)(23726002)(33716001)(64706001)(31966008)(50466002)(95666004)(4396001)(21056001)(102836001)(86362001)(76482002)(92566001)(20776003)(47776003)(46406003)(86152002)(110136001)(101416001)(97736003)(77096002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014, Guenter Roeck wrote:

> On Wed, Oct 15, 2014 at 01:55:09PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add support for simple on/off control of each channel.
> > 
> > To add regulator support, the pmbus part driver needs to add
> > regulator_desc information and number of regulators to its
> > pmbus_driver_info struct.
> > 
> > regulator_desc can be declared using default macro for a
> > regulator (PMBUS_REGULATOR) that is in pmbus.h
> > 
> > The regulator_init_data can be initialized from either
> > platform data or the device tree.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> 
> Hi Alan,
> 
> I am still seeing lots of the following:
> 
> vout0: Failed to create debugfs directory
> vout1: Failed to create debugfs directory
> vout2: Failed to create debugfs directory
> vout3: Failed to create debugfs directory
> vout4: Failed to create debugfs directory
> vout5: Failed to create debugfs directory
> vout6: Failed to create debugfs directory
> vout7: Failed to create debugfs directory
> 
> I thought there was a problem in the regulator core, but after looking
> into it concluded that the regulator core _should_ prepend the names
> with the device name when creating the debugfs entries, unless no device
> name is specified. So something must be missing. We'll need to sort
> this out before I can accept the code.
> 
> Thanks,
> Guenter
> 

Hi Guenter,

OK, I will look into it.

Alan
