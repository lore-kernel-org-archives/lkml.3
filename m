Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbbALNtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:49:25 -0500
Received: from mail-bn1on0074.outbound.protection.outlook.com ([157.56.110.74]:43616
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751675AbbALNtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:49:22 -0500
Date: Mon, 12 Jan 2015 14:48:47 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>, atull <atull@opensource.altera.com>
CC: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, <jason@lakedaemon.net>,
        <kyle.teske@ni.com>, <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        Rob Landley <rob@landley.net>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, Linus Walleij <linus.walleij@linaro.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devel@driverdev.osuosl.org>, Alan Tull <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <4D4EA2D5-68DD-49F7-9E2D-3A0A8F6AF9CA@konsulko.com>
 <20150110151118.GA16036@amd> <alpine.DEB.2.10.1501111009180.2556@shineypoop>
 <20150112084530.GA28681@amd>
In-Reply-To: <20150112084530.GA28681@amd>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21242.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <bed1d7ce1b984c79acc75a47495cb959@BL2FFO11FD043.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(479174004)(51704005)(377454003)(50944004)(377424004)(199003)(24454002)(52044002)(189002)(65956001)(6806004)(19580405001)(19580395003)(83506001)(106466001)(86362001)(50986999)(54356999)(76176999)(50466002)(87936001)(64706001)(64126003)(47776003)(65806001)(74316001)(62966003)(108616004)(93886004)(77096005)(2950100001)(77156002)(92726002)(104016003)(23676002)(92566002)(46102003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB019;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB019;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB019;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB019;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 13:49:14.9513
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 09:45 AM, Pavel Machek wrote:
> On Sun 2015-01-11 10:29:00, atull wrote:
>> On Sat, 10 Jan 2015, Pavel Machek wrote:
>>
>>> On Sat 2015-01-10 10:10:51, Pantelis Antoniou wrote:
>>>> Hi Pavel,
>>>>
>>>>> On Jan 9, 2015, at 22:56 , Pavel Machek <pavel@denx.de> wrote:
>>>>>
>>>>> On Fri 2015-01-09 13:14:24, atull wrote:
>>>>>> On Wed, 7 Jan 2015, Pavel Machek wrote:
>>>>>>
>>>>>>> On Tue 2015-01-06 14:13:37, atull@opensource.altera.com wrote:
>>>>>>>> +
>>>>>>>> +What:		/sys/class/fpga_manager/<fpga>/firmware
>>>>>>>> +Date:		October 2014
>>>>>>>> +KernelVersion:	3.18
>>>>>>>> +Contact:	Alan Tull <atull@opensource.altera.com>
>>>>>>>> +Description:	Name of the FPGA image file to load using firmware
>>>>>>>> class.
>>>>>>>
>>>>>>> This one is ugly: it unneccessarily passes firmware name through the
>>>>>>> kernel. Just make interface and code simpler by always passing
>>>>>>> "socfpga-fpga-image" or something like that.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> 									Pavel
>>>>>>
>>>>>> Hi Pavel,
>>>>>>
>>>>>> It might be ugly.  It's not unnecessary.  Some uses of FPGAs involve
>>>>>> switching out the FPGA images dynamically under control of the userspace.
>>>>>
>>>>> Then configure udev to load right firmware for you, or ln -s
>>>>> image-i-want-now socfpga-fpga-image to select the one to read…?
>>>>>
>>>>
>>>> Who said that udev is going to be available in the kind of system this is going to end in?
>>>
>>> Noone.
>>>
>>>> Doing ln -s tricks to load a different image? Really?
>>>
>>> But if you don't have udev, you can do ln -s. It is better than
>>> open-coding symlink functionality into
>>> /sys/class/fpga_manager/<fpga>/firmware ... cause that's what this is.
>>>
>>> Actually, clean implementation of "firmware" would be symlink in
>>> sysfs; but I'd say that would be overdoing it.
>>>
>>>> I say the interface is fine as it is.
>>>
>>> I say it is not.
>>> 									Pavel
>>
>> Hi Pavel,
>>
>> I see that we could do it that way and it would eliminate one of the
>> sysfs files (../fpga_manager/<fpga>/firmware).  Either way we are assuming
>> that there are fpga images in the filesystem in the firmware search path,
>> so I don't see why adding a piece of indirection (symlink) makes things
>> better.
> 
> Well.. you are basically re-implementing symlink with
> ../fpga_manager/<fpga>/firmware "file" in sysfs, and doing it
> badly. It has no advantages over real symlink.
> 
>> We want to be able to switch out the FPGA image
>> under control of userspace.  So we don't want an interface that makes
>> it more cumbersome or tries to pretend that there's only one image.
> 
> What is cumbersome about symlink? Why is "fake" symlink in sysfs better?
> 
>> Previous uses of the firmware layer has been to use it to load once after
>> bootup; this is different since some use cases will want to switch out
>> the FPGA image.  If someone wants there to be only one FPGA image on
>> the FGPA forever, they will probably not be using this framework; their
>> FPGA will probably be loaded before Linux boots up.
> 
> Why? I have just one image on the fpga, and would prefer to load it
> from Linux.

Pavel: These patches target staging and sysfs interface doesn't need to be stable
at this time. I would prefer to add these patches to staging for 3.20
and feel free to send the patch which fix this.
With your code will be exactly clear how you want to use it and we can
talk about it.

Thanks,
Michal



