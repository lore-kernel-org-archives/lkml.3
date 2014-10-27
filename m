Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaJ0Seu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:34:50 -0400
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:12786
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751650AbaJ0Set (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:34:49 -0400
X-WSS-ID: 0NE48XS-08-ZH7-02
X-M-MSG: 
Message-ID: <544E9038.5050004@amd.com>
Date: Mon, 27 Oct 2014 13:34:32 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Thomas Lendacky" <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20141027135035.GA2629@leverpostej>
In-Reply-To: <20141027135035.GA2629@leverpostej>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(164054003)(51914003)(24454002)(377454003)(51704005)(479174003)(199003)(64706001)(47776003)(20776003)(65806001)(65956001)(97736003)(87936001)(64126003)(85852003)(4396001)(50466002)(80022003)(36756003)(46102003)(33656002)(23676002)(68736004)(92566001)(110136001)(50986999)(76176999)(83506001)(101416001)(102836001)(87266999)(54356999)(65816999)(31966008)(107046002)(86362001)(76482002)(95666004)(99396003)(106466001)(80316001)(92726001)(44976005)(105586002)(120886001)(120916001)(59896002)(85306004)(84676001)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp02.amd.com;FPR:;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 8:50 AM, Mark Rutland wrote:
> Hi Suravee,
>
> [...]
>
>> +	chosen {
>> +		linux,stdout-path = "console=ttyAMA0,115200 earlycon=pl011,0xe1010000";
>
> The stdout-path property should just be a path to the UART node. It's
> not a direct replacement for /chosen/bootargs.
>
> This should be (assuming you fix up the label above):
>
> 	stdout-path = &serial0;
>
> That will give us earlycon if "earlycon" (with no arguments) is provided
> on the command line, and should set up that UART as the console. There's
> no need for the "linux," prefix now either.
>
> Unfortuantely, I believe that the UART rate will get changed when the
> real PL011 driver registers, unless the rate is explicitly provided on
> the command line. It might be worth looking into retaining the
> configured rate somehow indepentent of bootargs (unless overriden).

Thanks for the explanation. I think I should be able to get rid of the 
"console=ttyAMA0,115200 earlycon=pl011,0xe1010000" altogether. I'll send 
out V2 soon.

Thanks,

Suravee

> Thanks,
> Mark.
>


