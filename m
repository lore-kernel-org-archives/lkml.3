Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaLSHbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:31:15 -0500
Received: from mail-by2on0086.outbound.protection.outlook.com ([207.46.100.86]:21343
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751243AbaLSHbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:31:13 -0500
Date: Fri, 19 Dec 2014 08:30:53 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: atull <atull@opensource.altera.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 4/6] staging: fpga manager: add driver for socfpga
 fpga manager
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com>
 <1418835289-15752-5-git-send-email-atull@opensource.altera.com>
 <6eecb422024845acaffe10e4c81faac9@BN1AFFO11FD047.protection.gbl>
 <alpine.DEB.2.02.1412181456530.30233@linuxheads99>
In-Reply-To: <alpine.DEB.2.02.1412181456530.30233@linuxheads99>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21186.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <6cfe4d79d058475282c1ed8b1ac15852@BN1AFFO11FD035.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(51704005)(199003)(189002)(377454003)(479174004)(24454002)(87936001)(65806001)(99396003)(46102003)(19580405001)(104016003)(19580395003)(65956001)(64706001)(20776003)(33646002)(6806004)(47776003)(50986999)(83506001)(54356999)(76176999)(93886004)(108616004)(62966003)(92726002)(77096005)(2950100001)(23746002)(107046002)(21056001)(106466001)(64126003)(50466002)(120916001)(74316001)(77156002)(86362001)(4396001)(31966008)(92566001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB060;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB060;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1AFFO11HUB060;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB060;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 09:59 PM, atull wrote:
> On Thu, 18 Dec 2014, Michal Simek wrote:
> 
> Hi Michal,
> 
>>> +
>>> +	/* Write out remaining non 32-bit chunks. */
>>> +	switch (count) {
>>> +	case 3:
>>> +		socfpga_fpga_data_writel(priv, buffer_32[i++] & 0x00ffffff);
>>> +		break;
>>> +	case 2:
>>> +		socfpga_fpga_data_writel(priv, buffer_32[i++] & 0x0000ffff);
>>> +		break;
>>> +	case 1:
>>> +		socfpga_fpga_data_writel(priv, buffer_32[i++] & 0x000000ff);
>>> +		break;
>>> +	default:
>>> +		/* This will never happen. */
>>
>> why not just return any error code here even if this can't happen.
>>
> 
> OK. Will be in v6.
> 
>>
>> add it to one line.
>>
>> The rest is looks good to me. I think this is good to go in.
>>
>> Acked-by: Michal Simek <michal.simek@xilinx.com>
>>
>> Thanks,
>> Michal
>>
> 
> Thanks for the feedback.  So patches 1-4 look good now?

Will look at them.

M

