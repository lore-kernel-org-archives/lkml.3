Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaLDR4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:56:07 -0500
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:21461
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932464AbaLDR4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:56:05 -0500
Message-ID: <54809C88.8060601@caviumnetworks.com>
Date: Thu, 4 Dec 2014 09:40:24 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <chenhc@lemote.com>, <cl@linux.com>,
        Ingo Molnar <mingo@kernel.org>, <richard@nod.at>, <zajec5@gmail.com>,
        <james.hogan@imgtec.com>, <keescook@chromium.org>, <tj@kernel.org>,
        <alex@alex-smith.me.uk>, <pbonzini@redhat.com>, <blogic@openwrt.org>,
        <paul.burton@imgtec.com>, <qais.yousef@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <lars.persson@axis.com>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/3] MIPS: Add full ISA emulator.
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com> <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com> <547FA2E5.1040105@imgtec.com> <547FA8D2.2030703@caviumnetworks.com> <alpine.LFD.2.11.1412040310100.22073@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.11.1412040310100.22073@eddie.linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: BY2PR07CA076.namprd07.prod.outlook.com (10.141.251.51) To
 CY1PR0701MB1114.namprd07.prod.outlook.com (25.160.145.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0701MB1114;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0701MB1114;
X-Forefront-PRVS: 041517DFAB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(24454002)(189002)(164054003)(377454003)(479174003)(199003)(69596002)(92566001)(87976001)(105586002)(68736005)(87266999)(40100003)(23756003)(54356999)(80316001)(99396003)(76176999)(99136001)(81156004)(120916001)(46102003)(77156002)(97736003)(122386002)(21056001)(50466002)(93886004)(64126003)(62966003)(107046002)(101416001)(106356001)(42186005)(20776003)(4396001)(33656002)(31966008)(53416004)(110136001)(36756003)(47776003)(64706001)(65816999)(50986999)(65956001)(65806001)(66066001)(83506001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0701MB1114;H:dl.caveonetworks.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0701MB1114;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 03:49 AM, Maciej W. Rozycki wrote:
> On Wed, 3 Dec 2014, David Daney wrote:
>
>>> but it doesn't support customized instructions,
>>
>> GCC will never put these in the delay slot of a FPU branch, so it is not
>> needed.
>>
>>> multiple ASEs,
>>
>> Same as above.  But any instructions that are deemed necessary can easily be
>> added.
>
>   GAS will happily schedule any instruction into a branch delay slot as
> long as the instruction is not architecturally forbidden there (e.g.
> ERET), there is no data dependency with the branch that would affect the
> result produced and the instruction is not an explicit exception trap
> operation (BREAK, SYSCALL, TEQ, etc.).  For some reason, unknown to me all
> MT ASE instructions are disallowed too.  Anything else -- free to go in!
>
>   Of course instructions can be scheduled into branch delay slots manually
> too, in handcoded assembly, and that has to continue working.
>

It is not difficult to also emulate the trapping instructions.  In order 
to move forward, I will implement the trapping instructions in my 
emulator for the next patch.

Thanks,
David Daney

