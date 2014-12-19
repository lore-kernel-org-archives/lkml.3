Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaLSOGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:06:12 -0500
Received: from mail-by2on0066.outbound.protection.outlook.com ([207.46.100.66]:38432
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbaLSOGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:06:07 -0500
Date: Fri, 19 Dec 2014 15:05:50 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        <atull@opensource.altera.com>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v6 4/4] staging: fpga manager: add driver for socfpga
 fpga manager
References: <1418941748-16111-1-git-send-email-atull@opensource.altera.com>
 <1418941748-16111-5-git-send-email-atull@opensource.altera.com>
 <20141219085516.GF13070@pengutronix.de>
In-Reply-To: <20141219085516.GF13070@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21186.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <2d65a072f8c14d1e839307465f177a1a@BY2FFO11FD046.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(51704005)(189002)(479174004)(24454002)(199003)(164054003)(50986999)(74316001)(83506001)(23746002)(92566001)(107046002)(104016003)(50466002)(106466001)(19580395003)(19580405001)(6806004)(86362001)(99396003)(64706001)(120916001)(20776003)(46102003)(65956001)(47776003)(65806001)(108616004)(4396001)(21056001)(64126003)(76176999)(87936001)(92726002)(54356999)(77156002)(62966003)(31966008)(2950100001)(77096005)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB014;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB014;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB014;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB014;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2014 09:55 AM, Steffen Trumtrar wrote:
> Hi!
> 
> Just a minor nitpick, but...
> 
> On Thu, Dec 18, 2014 at 04:29:08PM -0600, atull@opensource.altera.com wrote:
>> From: Alan Tull <atull@opensource.altera.com>
>>
>> Add driver to fpga manager framework to allow configuration
>> of FPGA in Altera SoCFPGA parts.
>>
>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>> Acked-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>> v2: fpga_manager struct now contains struct device
>>     fpga_manager_register parameters now take device
>>
>> v3: skip a version to align versions
>>
>> v4: move to drivers/staging
>>
>> v5: fix array_size.cocci warnings
>>     fix platform_no_drv_owner.cocci warnings
>>     Remove .owner = THIS_MODULE
>>     include asm/irq.h
>>     clean up list of includes
>>     use altera_fpga_reset for ops
>>     use enum fpga_mgr_states or u32 as needed
>>     use devm_request_irq
>>     check irq <= 0 instead of == NO_IRQ
>>     Use ARRAY_SIZE
>>     rename altera -> socfpga
>>     static const socfpga_fpga_ops
>>     header moved to linux/fpga/ folder
>>     remove ifdef'ed code
>>     use platform_get_resource and platform_get_irq
>>     move .probe and .remove lines adjacent
>>     use module_platform_driver
>>     use __maybe_unused
>>     only need to 'if (IS_ENABLED(CONFIG_REGULATOR))' in one fn
>>     fix "unsigned 'mode' is never < 0"
>>
>> v6: return error for (unused) default of case statement
>> ---
>   ^^^
> 
> ...if you remove these, than that changelog will not land in the final
> commit which I would prefer. Nobody cares for the changelog of a
> patch once it is in its final state. And this is a rather noisy one.
> When someone in the future looks at this, he will see two lines of
> information and 10 times that of uninteresting noise.
> 
> Not a dealbreaker, but just something to consider for future patches.


When you run git-am you will see that changelog is not there.

I can't see any problem here. Can you please try it or clear what
are you referring to here?

Thanks,
Michal

