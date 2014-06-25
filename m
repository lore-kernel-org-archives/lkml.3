Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaFYUP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:15:26 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:23214
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755444AbaFYUPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:21 -0400
X-WSS-ID: 0N7QQWW-08-3HC-02
X-M-MSG: 
Message-ID: <53AB2DBA.8040407@amd.com>
Date: Wed, 25 Jun 2014 15:14:50 -0500
From: Joel Schopp <joel.schopp@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Anup Patel <anup@brainfault.org>, Marc Zyngier <marc.zyngier@arm.com>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
 <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
 <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
In-Reply-To: <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(51704005)(189002)(95666004)(65956001)(31966008)(15202345003)(53416004)(77982001)(79102001)(74662001)(65806001)(102836001)(23756003)(87936001)(74502001)(4396001)(54356999)(92566001)(92726001)(85852003)(107046001)(47776003)(64706001)(19580395003)(85306003)(81342001)(36756003)(97736001)(84676001)(64126003)(65816999)(80022001)(76176999)(83322001)(50466002)(83506001)(20776003)(81542001)(83072002)(21056001)(76482001)(50986999)(33656002)(105586002)(80316001)(46102001)(68736004)(59896001)(77096002)(106466001)(101416001)(99396002)(86362001)(15975445006)(44976005)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY1PR0201MB0918;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Joel.Schopp@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +               if (resource_size(&cpu_res) >= SZ_8K)
>> +                       supports_deactivate = true;
>> +               else
>> +                       pr_warn("GIC: CPU interface size is %x, DT is probably wrong\n", (int)resource_size(&cpu_res));
> This will not work on APM X-Gene because, for
> X-Gene first CPU page is at 0x78020000 and
> second CPU page is at 0x78030000.
>
> Ian had send-out a patch long time back to extend
> GIC dt-bindings for addressing this issue.
> (http://www.spinics.net/lists/arm-kernel/msg283767.html)

We have a similar issue with an AMD SOC.  You can add 0xf000 (60K) page 
offset to it to cleverly work around the issue but it seems quite likely 
that the page offset has to be communicated to userspace and handled 
there at no small effort.

Anybody want to revive Ian's split patches?  They do seem convoluted but 
seem like they might work as an approach.

-Joel

