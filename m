Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaKCT5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:57:54 -0500
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:41424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752990AbaKCT5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:57:48 -0500
X-WSS-ID: 0NEHBG4-07-PHK-02
X-M-MSG: 
Message-ID: <5457DE29.4020907@amd.com>
Date: Mon, 3 Nov 2014 13:57:29 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V9 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
References: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1414743990-28421-3-git-send-email-suravee.suthikulpanit@amd.com>
 <54574FF7.706@arm.com> <54578CC7.4050901@arm.com>
In-Reply-To: <54578CC7.4050901@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(164054003)(24454002)(479174003)(377454003)(51704005)(189002)(21056001)(102836001)(64126003)(106466001)(95666004)(50466002)(23746002)(84676001)(83506001)(68736004)(80316001)(44976005)(120916001)(92566001)(62966003)(93886004)(99396003)(33656002)(101416001)(46102003)(105586002)(31966008)(92726001)(107046002)(64706001)(86362001)(4396001)(54356999)(65816999)(87266999)(76176999)(50986999)(110136001)(47776003)(20776003)(36756003)(65806001)(65956001)(87936001)(97736003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/2014 8:10 AM, Marc Zyngier wrote:
> On 03/11/14 09:50, Marc Zyngier wrote:
>
>>> @@ -843,10 +847,14 @@ static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
>>>          unsigned int type = IRQ_TYPE_NONE;
>>>          struct of_phandle_args *irq_data = arg;
>>>
>>> -       ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
>>> -                                  irq_data->args_count, &hwirq, &type);
>>> -       if (ret)
>>> -               return ret;
>>> +       if (irq_data) {
>>> +               ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
>>> +                                          irq_data->args_count, &hwirq, &type);
>>> +               if (ret)
>>> +                       return ret;
>>> +       } else {
>>> +               hwirq = virq;
>>> +       }
>>
>> I'm slightly puzzled here. What's the purpose of this? The whole goal of
>> the domain hierarchy is to avoid that kind of thing. Also, you should
>> never have to call xlate on an MSI, because it should never be described
>> in the device tree the first place.
>
> Thinking of it some more:
>
> The actual reason why this is required is because the MSI domain calls
> into this via irq_domain_alloc_irqs_parent(). But because MSIs are not
> described in DT, they do not have a of_phandle to pass down to the xlate
> helper. In this case, the v2m widget has the knowledge of what are the
> valid SPI numbers, and the core GIC code must blindly accept it.
>
> This definitely requires a fat comment, because this is far from obvious.
>
> Thanks,
>
> 	M.
>

I'll put in proper comments here.

Suravee

