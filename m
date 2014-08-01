Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaHAQTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:19:41 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:42711
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754842AbaHAQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:19:38 -0400
X-WSS-ID: 0N9MYOF-08-IPK-02
X-M-MSG: 
Message-ID: <53DBBE06.5040307@amd.com>
Date: Fri, 1 Aug 2014 11:19:18 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/4 V3] irqchip: gicv2m: Add support for multiple MSI
 for ARM64 GICv2m
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1404947104-21345-5-git-send-email-suravee.suthikulpanit@amd.com>
 <87vbqej2rj.fsf@approximate.cambridge.arm.com> <53DBA603.9030509@amd.com>
 <53DBA986.90705@arm.com>
In-Reply-To: <53DBA986.90705@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(51704005)(24454002)(164054003)(479174003)(377454003)(92566001)(80022001)(65806001)(65956001)(92726001)(4396001)(97736001)(36756003)(93886004)(85306004)(64706001)(106466001)(81342001)(47776003)(46102001)(110136001)(20776003)(107046002)(83072002)(105586002)(87936001)(23746002)(64126003)(85852003)(59896001)(77982001)(83506001)(101416001)(76482001)(76176999)(87266999)(50986999)(65816999)(102836001)(81542001)(54356999)(33656002)(99396002)(86362001)(21056001)(74502001)(50466002)(74662001)(68736004)(31966008)(83322001)(95666004)(80316001)(84676001)(79102001)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB047;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2014 9:51 AM, Marc Zyngier wrote:
> Hi Suravee,
>
> On 01/08/14 15:36, Suravee Suthikulanit wrote:
>> On 7/30/2014 10:16 AM, Marc Zyngier wrote:
>>> Why do we need this complexity at all? Is there any case where we'd want
>>> to limit ourselves to a single vector for MSI?
>>
>> I think the ARM64 GICv2m should not be the limitation for the devices
>> multiple MSI if there is no real hardware/design limitation.
>>
>>> arm64 is a new enough architecture so that we can expect all interrupt controllers to cope
>>> with that.
>>
>> I am not sure if I understand this comment.
>>
>> We are not forcing all interrupt controllers for ARM64 to handle
>> multi-MSI.  They have the option to support if multi-MSI if they want
>> to. I just think that we should not put the architectural limit here.
>
> Let me be clearer: I think we should put the burden of *not* handling
> multi-MSI on interrupt controllers. Here, you're making the
> architectural default to be "I don't support multi-MSI", hence having to
> override global vectors and such for well behaved MSI controllers like
> GICv2m and GICv3 ITS.
>
> Let's only support multi-MSI for the time being. If someone comes up
> with a silly old MSI controller that can't deal with it, we'll address
> the issue at that problem.
>
> Thanks,
>
> 	M.
>

Ok, I'm fine with that. Thanks for clarification.

Suravee

