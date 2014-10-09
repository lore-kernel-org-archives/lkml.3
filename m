Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaJINQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:16:37 -0400
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:13376
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751190AbaJINQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:16:29 -0400
Message-ID: <54368AA2.9000104@opensource.altera.com>
Date: Thu, 9 Oct 2014 08:16:18 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <s.trumtrar@pengutronix.de>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <atull@opensource.altera.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early initialization
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com> <1412845410.6809.3.camel@pengutronix.de>
In-Reply-To: <1412845410.6809.3.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BY2PR07CA077.namprd07.prod.outlook.com (10.141.251.52) To
 CY1PR0301MB1193.namprd03.prod.outlook.com (25.160.165.24)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1193;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(199003)(479174003)(377454003)(189002)(51704005)(33656002)(86362001)(21056001)(76482002)(50466002)(65816999)(85852003)(83506001)(65806001)(66066001)(92726001)(92566001)(64706001)(85306004)(19580405001)(80316001)(102836001)(20776003)(47776003)(42186005)(110136001)(19580395003)(50986999)(54356999)(99396003)(87266999)(99136001)(64126003)(120916001)(23676002)(80022003)(46102003)(87976001)(76176999)(122386002)(95666004)(105586002)(106356001)(77096002)(65956001)(97736003)(107046002)(31966008)(40100002)(4396001)(59896002)(101416001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1193;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 10/9/14, 4:03 AM, Philipp Zabel wrote:
> Am Mittwoch, den 08.10.2014, 21:44 -0500 schrieb
> dinguyen@opensource.altera.com:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>
>> There are certain drivers that are required to get loaded very early using
>> arch_initcall. An example of such a driver is the SOCFPGA's FPGA bridge driver.
>> This driver has to get loaded early because it needs to enable FPGA components
>> that are connected to the bridge.
>>
>> This FPGA bridge driver will using the reset controller API to toggle it's
>> reset bits, thus, it needs the reset driver to be loaded as early as possible
>> in order for it to get used properly.
> 
> Without knowing the details, this sounds like the wrong approach. Can't
> the bridge driver return -EPROBE_DEFER until the reset controller is
> available?
> 

The bridge driver is also using arch_initcall, as it also needs to get
loaded early for FPGA IPs to work, and so later driver loading will work
for the FPGA IPs.

Dinh
