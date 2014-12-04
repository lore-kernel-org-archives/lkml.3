Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaLDChd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:37:33 -0500
Received: from mail-bn1on0074.outbound.protection.outlook.com ([157.56.110.74]:46688
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbaLDChc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:37:32 -0500
X-Greylist: delayed 942 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2014 21:37:31 EST
Message-ID: <547FC530.1060109@caviumnetworks.com>
Date: Wed, 3 Dec 2014 18:21:36 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <macro@linux-mips.org>,
        <chenhc@lemote.com>, <cl@linux.com>, <mingo@kernel.org>,
        <richard@nod.at>, <zajec5@gmail.com>, <james.hogan@imgtec.com>,
        <keescook@chromium.org>, <tj@kernel.org>, <alex@alex-smith.me.uk>,
        <pbonzini@redhat.com>, <blogic@openwrt.org>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <markos.chandras@imgtec.com>, <dengcheng.zhu@imgtec.com>,
        <manuel.lauss@gmail.com>, <lars.persson@axis.com>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/3] MIPS: Add full ISA emulator.
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com> <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com> <547FA2E5.1040105@imgtec.com> <547FA8D2.2030703@caviumnetworks.com> <547FB032.2000000@imgtec.com> <547FB8FB.7040803@caviumnetworks.com> <547FBF63.70802@imgtec.com>
In-Reply-To: <547FBF63.70802@imgtec.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: BLUPR07CA0049.namprd07.prod.outlook.com (10.255.223.162) To
 BY1PR0701MB1112.namprd07.prod.outlook.com (25.160.104.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0701MB1112;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0701MB1112;
X-Forefront-PRVS: 041517DFAB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(199003)(479174003)(377454003)(189002)(51704005)(47776003)(20776003)(64706001)(93886004)(65806001)(122386002)(77156002)(66066001)(65956001)(62966003)(110136001)(59896002)(46102003)(95666004)(105586002)(106356001)(92726001)(92566001)(21056001)(99396003)(42186005)(53416004)(120916001)(36756003)(50466002)(40100003)(68736005)(87976001)(87266999)(33656002)(65816999)(64126003)(107046002)(31966008)(80316001)(69596002)(4396001)(97736003)(19580395003)(102836001)(50986999)(101416001)(54356999)(15202345003)(76176999)(83506001)(15975445006);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0701MB1112;H:dl.caveonetworks.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0701MB1112;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 05:56 PM, Leonid Yegoshin wrote:
> David,
>
> I feel we can close a discission at that point - we disagree which
> approach is better, and there is no sense to continue dancing around.
>

That is something I do agree with.

> I see only two technical issues here which differs:
>
> 1.  You believe your GCC experts, I trust HW Architecture manual and
> don't trust toolchain people too much ==> we see a different value in
> fact that your approach has a subset of emulated ISAs (and it can't, of
> course, emulate anything because some custom opcodes are reused).

Yes, I agree that the emulation approach cannot handle some of the cases 
you mention (most would have to be the result of hand coded assembly 
specifically trying to break it).

>
> 2.  My approach is ready to use and is used right now, you still have a
> framework which passed an initial boot.


Let's add some more, please correct me if I misstate the facts:

3) Your approach uses one additional page of memory per user space 
thread, even if emulation is never needed or there is a hardware FPU.

4) Your approach adds a Thread creation overhead of copy_page().

>
>
> On 12/03/2014 05:29 PM, David Daney wrote:
>> On 12/03/2014 04:52 PM, Leonid Yegoshin wrote:
>>> On 12/03/2014 04:20 PM, David Daney wrote:
>>>> It is a proof of concept.  R6 can easily be added if needed.
>>>>
>>>> Your XOL emulation doesn't handle R6 either, so this is no worse than
>>>> your patch in that respect.
>>>
>>> You probably didn't research it well. A lot of changes in
>>> arch/mips/kernel/branch.c and and arch/mips/math-emu/cp1emu.c, all of it
>>> related with R6.
>>>
>>
>> I looked at:
>> commit 3a18ca061311f2f1ee9c44012f89c7436d392117
>>
>> And I saw no R6 support.
>>
>> Is it there, or in some other branch that isn't merged?
>
> Sorry, I misunderstood your statement:
>
> Yes, my "MIPS: Setup an instruction emulation in VDSO protected page
> instead of user stack <http://patchwork.linux-mips.org/patch/8631/>" has
> no any MIPS R6 specifics and actually has no any another MIPS Rx
> specific or FPU specific besides the fact that emulation can be done by
> multiple emulators and a small stack is supported in so-called "VDSO"
> page. I just remember that I pointed you to place where MIPS R6 is done
> and it has a lot of MIPS R6 instruction emulation and confused both events.
>
> - Leonid.

