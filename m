Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaJAU06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:26:58 -0400
Received: from mail-bn1bon0058.outbound.protection.outlook.com ([157.56.111.58]:29120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752085AbaJAU0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:26:55 -0400
Date: Wed, 1 Oct 2014 15:20:41 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 0/4] regulator support for pmbus and ltc2978
In-Reply-To: <20141001200743.GA21388@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1410011519001.2317@atx-linux-37>
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com> <20141001200743.GA21388@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0061.namprd05.prod.outlook.com (10.141.20.31) To
 BLUPR03MB309.namprd03.prod.outlook.com (10.141.48.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB309;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(51704005)(24454002)(199003)(87976001)(106356001)(31966008)(66066001)(81156004)(105586002)(85852003)(95666004)(99396003)(46406003)(33716001)(85306004)(86152002)(107046002)(20776003)(47776003)(50466002)(23726002)(4396001)(64706001)(120916001)(110136001)(15202345003)(54356999)(86362001)(92726001)(77096002)(42186005)(92566001)(15975445006)(83506001)(101416001)(69596002)(19580405001)(19580395003)(10300001)(76482002)(76176999)(50986999)(102836001)(97736003)(53416004)(46102003)(80022003)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB309;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Guenter Roeck wrote:

> On Wed, Oct 01, 2014 at 02:05:46PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > This set of patches adds regulator support for pmbus_core.c and ltc2978.c
> > 
> > Each output has individual on/off control.
> > 
> > From PMBus_Specification_Part_II_Rev_1-3_20140318.pdf: 12.1.1. OPERATION
> > Command Bit [7] Bit [7] controls whether the PMBus device output is on or off.
> > If bit [7] is cleared (equals 0), then the output is off.  If bit [7] is set
> > (equals 1), then the output is on.
> > 
> > Fixes in v4 are not huge: Add device tree bindings documentation for ltc2978.
> > rename _pmbus_regulator_enable to _pmbus_regulator_on_off simplify
> > _pmbus_regulator_on_off code s/regulator_regulator/regulator/ fix build break
> > when !CONFIG_REGULATOR remove unused #define PB_OPERATION_CONTROL_SEQ_OFF fix
> > a #endif comment simplify probe code, remove added switch statement remove
> > BUG_ON(), add error message and fix num_regulators
> > 
> > Patch 1: document device tree bindings for ltc2978
> > 
> > Patch 2: add two helper functions for byte pmbus byte operations * byte write
> > and byte read/modify/write
> > 
> > Patch 3: regulator support added in pmbus_core.c and pmbus.h * regulator_ops
> > functions (is_enabled, enable, and disable) * gets regulator init data from
> > device tree or platform data * registers the regulators * header has a macro
> > for chip drivers to build their regulator_desc data
> > 
> > Patch 4: changes for ltc2978.c * Add Kconfig to enable/disable ltc2978
> > regulator functionality * add regulator_desc and of_regulator_match info * use
> > same structs for all parts; set num_regulators appropriately.
> > 
> Looks like this patch got lost. I did not get it, and I don't see it on lkml
> either.
> 
> Guenter

Yes I missed it.  Just sent patch 0004 out.

Alan


> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
