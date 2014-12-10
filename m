Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaLJPYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:24:45 -0500
Received: from mail-bn1on0096.outbound.protection.outlook.com ([157.56.110.96]:10064
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757293AbaLJPYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:24:43 -0500
Date: Wed, 10 Dec 2014 16:24:25 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>
CC: <atull@opensource.altera.com>, <jgunthorpe@obsidianresearch.com>,
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
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 4/6] fpga manager: add sysfs interface document
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
 <1418156090-23578-5-git-send-email-atull@opensource.altera.com>
 <c234f48c2ff145b4810cef72482bb49c@BL2FFO11FD045.protection.gbl>
 <20141210144724.GA17184@kroah.com>
In-Reply-To: <20141210144724.GA17184@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21164.004
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <4efe5243e781496082b814f7ccdd1b43@BN1BFFO11FD038.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(51704005)(189002)(199003)(164054003)(24454002)(479174003)(86362001)(4396001)(65806001)(65956001)(83506001)(77156002)(92726002)(92566001)(31966008)(62966003)(64706001)(47776003)(23746002)(93886004)(108616004)(6806004)(87936001)(50986999)(76176999)(19580395003)(54356999)(74316001)(19580405001)(50466002)(21056001)(20776003)(120916001)(106466001)(33646002)(99396003)(77096005)(46102003)(107046002)(104016003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB030;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB030;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB030;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB030;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 03:47 PM, Greg KH wrote:
> On Wed, Dec 10, 2014 at 10:42:39AM +0100, Michal Simek wrote:
>> Hi Greg,
>>
>> On 12/09/2014 09:14 PM, atull@opensource.altera.com wrote:
>>> From: Alan Tull <atull@opensource.altera.com>
>>>
>>> Add documentation for new fpga manager sysfs interface.
>>>
>>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>>> ---
>>>  Documentation/ABI/testing/sysfs-class-fpga-manager |   38 ++++++++++++++++++++
>>>  1 file changed, 38 insertions(+)
>>>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager
>>
>> What's the rule for adding sysfs doc for driver which is added to staging?
>> Is this location fine?
> 
> No, staging drivers should be "self-contained" so when^Wif we delete
> them, it is easy to do so :)
> 
> Put it in the same directory as your driver.

That's what I thought.
Thanks for confirmation.

Thanks,
Michal

