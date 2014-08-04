Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaHDQCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:02:41 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:17679
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbaHDQCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:02:38 -0400
Message-ID: <53DFB030.1070406@opensource.altera.com>
Date: Mon, 4 Aug 2014 11:09:20 -0500
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Lee Jones <lee.jones@linaro.org>, <robherring2@gmail.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <atull@altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <sameo@linux.intel.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tthayer.linux@gmail.com>, Alan Tull <atull@opensource.altera.com>
Subject: Re: [PATCHv9 1/3] mfd: altera: Add Altera SDRAM Controller
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com> <1406744573-609-2-git-send-email-tthayer@opensource.altera.com> <20140731082637.GH9030@lee--X1> <53DAA072.4010902@opensource.altera.com> <20140801081317.GL9030@lee--X1> <53DC146D.1070504@opensource.altera.com> <20140802170811.GA20550@pengutronix.de>
In-Reply-To: <20140802170811.GA20550@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0054.namprd05.prod.outlook.com (10.141.20.24) To
 BY2PR03MB128.namprd03.prod.outlook.com (10.242.36.28)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(6049001)(479174003)(51704005)(377454003)(164054003)(24454002)(189002)(199002)(54356999)(85852003)(66066001)(33656002)(15975445006)(76176999)(46102001)(110136001)(107046002)(74662001)(77096002)(21056001)(106356001)(101416001)(105586002)(65816999)(81542001)(93886004)(87266999)(42186005)(81342001)(50986999)(87976001)(99396002)(85306004)(83506001)(92566001)(86362001)(15395725005)(23756003)(50466002)(92726001)(83322001)(102836001)(19580395003)(77982001)(83072002)(31966008)(65956001)(64126003)(65806001)(47776003)(80022001)(79102001)(95666004)(76482001)(80316001)(19580405001)(15202345003)(74502001)(20776003)(4396001)(64706001)(6606295002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB128;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/02/2014 12:08 PM, Steffen Trumtrar wrote:
> Hi!
>
> On Fri, Aug 01, 2014 at 05:27:57PM -0500, Thor Thayer wrote:
>> On 08/01/2014 03:13 AM, Lee Jones wrote:
>>> On Thu, 31 Jul 2014, Thor Thayer wrote:
>>>> On 07/31/2014 03:26 AM, Lee Jones wrote:
>>>>> On Wed, 30 Jul 2014, tthayer@opensource.altera.com wrote:
> [...]
>
>>>>>> +u32 altera_sdr_readl(struct altera_sdr *sdr, u32 reg_offset)
>>>>>> +{
>>>>>> +	return readl(sdr->reg_base + reg_offset);
>>>>>> +}
>>>>>> +EXPORT_SYMBOL_GPL(altera_sdr_readl);
>>>>>> +
>>>>>> +void altera_sdr_writel(struct altera_sdr *sdr, u32 reg_offset, u32 value)
>>>>>> +{
>>>>>> +	writel(value, sdr->reg_base + reg_offset);
>>>>>> +}
>>>>>> +EXPORT_SYMBOL_GPL(altera_sdr_writel);
>> We'd prefer to use syscon and that is what we started with. If you'd
>> like to be our advocate, I will return to that because it was pretty
>> clean. My primary concern is to get it upstreamed and if it is MFD
>> then I'll make the changes.
>>
>> Here are the threads.
>> http://marc.info/?l=linux-kernel&m=140128791902800&w=2
> The conclusion of this thread was syscon for offset 0x0, no ?!
> And if you decide to have new writel/readl functions, I'd prefer if you don't
> change the order of parameters just because. That always weirds me out, when
> there are vendorname_writel functions, that only change the API of writel and
> nothing else (not exactly the case here).
Hi Steffen,

Yes, I see your point on the order of parameters. i will change it.

As for the syscon only at offset 0, I submitted that in version 7 & 8. 
It wasn't as clean as the version using syscon for the entire range.  It 
could also require changes to the SDRAM controller binding as things are 
added in the future.  My understanding is the bindings should not change 
significantly and changes are frowned upon.

After going through this exercise in a couple of different ways, I'm 
leaning toward using syscon for the entire SDRAM controller register range.

Is there a good reason not to use syscon on the entire register range?

Thanks,

Thor
>
> Regards,
> Steffen
>

