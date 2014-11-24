Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaKXOdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:33:12 -0500
Received: from mail-bn1on0095.outbound.protection.outlook.com ([157.56.110.95]:25474
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753696AbaKXOdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:33:10 -0500
Date: Mon, 24 Nov 2014 15:32:52 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, Michal Simek <michal.simek@xilinx.com>
CC: <soren.brinkmann@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: FIX ME in xsysace.c
References: <5472B1D6.7080805@gmail.com>
 <5a8be93a4204429daf16bc8f62cdd0cd@BY2FFO11FD005.protection.gbl>
 <54731648.8010006@gmail.com>
In-Reply-To: <54731648.8010006@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21124.007
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <5e95919de4e349a6a7c5261cb1e9fda5@BN1BFFO11FD012.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51704005)(24454002)(164054003)(479174003)(377454003)(199003)(377424004)(65806001)(108616004)(50986999)(54356999)(104016003)(23676002)(31966008)(65956001)(50466002)(106466001)(44976005)(74316001)(4396001)(6806004)(76176999)(21056001)(95666004)(92566001)(77156002)(20776003)(83506001)(62966003)(47776003)(33646002)(99396003)(87936001)(107046002)(64126003)(64706001)(86362001)(46102003)(120916001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB017;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB017;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB017;
X-Forefront-PRVS: 040513D301
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB017;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/24/2014 12:28 PM, nick wrote:
> 
> 
> On 14-11-24 02:47 AM, Michal Simek wrote:
>> Hi,
>>
>> On 11/24/2014 05:19 AM, nick wrote:
>>> Greetings Michal and others,
>>> I am wondering about the FIX ME in xsysace.c as it seems not correct due to my knowledge of most hardware protocols using a predetermined bit wide and therefore this could be hard coded. If someone can respond on if I am correct in removing this fix me it would be greatly appreciated.
>>
>> I think that will be the best to c&p that fixme which you are talking about.
>> Definitely feel free to fix whatever fixme is there and send the patch
>> for fixing it.
>>
>> Thanks,
>> Michal
>>
> Here is the fix me.
> int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */

FIXME is totally bogus and should be removed.

I expect you want to use 8bit bus mode which driver itself supports.
This line is just default setup to 16bit mode.

If you add 8-bit property to dts you are there.
	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
		bus_width = ACE_BUS_WIDTH_8;

Thanks,
Michal
