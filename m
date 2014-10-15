Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaJOOJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:09:17 -0400
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:3681
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbaJOOJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:09:16 -0400
X-Greylist: delayed 940 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2014 10:09:15 EDT
Message-ID: <543E7C56.3090508@opensource.altera.com>
Date: Wed, 15 Oct 2014 08:53:26 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        atull <atull@opensource.altera.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>, <dinh.linux@gmail.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early initialization
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com> <1412845410.6809.3.camel@pengutronix.de> <54368AA2.9000104@opensource.altera.com> <20141009132835.GI15799@pengutronix.de> <alpine.DEB.2.02.1410090950540.17462@atx-linux-37> <20141009151935.GK15799@pengutronix.de> <alpine.DEB.2.02.1410101123590.11270@atx-linux-37> <alpine.DEB.2.02.1410141322160.11888@atx-linux-37> <20141015100247.GB6255@pengutronix.de>
In-Reply-To: <20141015100247.GB6255@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BY2PR03CA042.namprd03.prod.outlook.com (10.141.249.15) To
 BN3PR0301MB1186.namprd03.prod.outlook.com (25.160.156.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1186;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(199003)(479174003)(377454003)(40100003)(101416001)(80316001)(80022003)(102836001)(46102003)(122386002)(33656002)(76482002)(120916001)(64126003)(50986999)(87266999)(54356999)(76176999)(31966008)(93886004)(65816999)(83506001)(85306004)(23756003)(87976001)(95666004)(105586002)(4396001)(107046002)(106356001)(59896002)(21056001)(77096002)(65956001)(66066001)(65806001)(97736003)(92726001)(92566001)(86362001)(50466002)(20776003)(47776003)(42186005)(85852003)(64706001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1186;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/15/14, 5:02 AM, Steffen Trumtrar wrote:
> Hi!
> 
> On Tue, Oct 14, 2014 at 01:45:29PM -0500, atull wrote:
>> The FPGA bridge driver that I submitted last year handled the following
>> things:
>>  * The bridges might have been brought out of reset in the bootloader. Some
>>    of the bridges have write-only registers (!) so this information had to
>>    be passed in DT
> 
> Regmap has infrastructure to handle this.
> 

The current implementation of Alan's bridge driver is using regmap to
toggle the reset manager bits. However, that required adding "syscon" to
the reset manager's DTS node. By doing this, the reset driver was not
able to load.

So that's the story behind why I'm looking to convert Alan's bridge
driver to use the reset driver.

Dinh
