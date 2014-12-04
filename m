Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaLDB3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:29:40 -0500
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:5664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbaLDB3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:29:39 -0500
X-Greylist: delayed 3201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2014 20:29:38 EST
Message-ID: <547FB8FB.7040803@caviumnetworks.com>
Date: Wed, 3 Dec 2014 17:29:31 -0800
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
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com> <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com> <547FA2E5.1040105@imgtec.com> <547FA8D2.2030703@caviumnetworks.com> <547FB032.2000000@imgtec.com>
In-Reply-To: <547FB032.2000000@imgtec.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: BY2PR07CA055.namprd07.prod.outlook.com (10.141.251.30) To
 DM2PR0701MB1120.namprd07.prod.outlook.com (25.160.246.151)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0701MB1120;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0701MB1120;
X-Forefront-PRVS: 041517DFAB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(24454002)(51704005)(199003)(377454003)(189002)(479174003)(31966008)(36756003)(68736005)(53416004)(21056001)(42186005)(92726001)(92566001)(40100003)(97736003)(110136001)(107046002)(69596002)(4396001)(122386002)(81156004)(106356001)(65806001)(83506001)(64706001)(105586002)(59896002)(47776003)(20776003)(95666004)(87976001)(65816999)(23746002)(87266999)(54356999)(102836001)(76176999)(50986999)(33656002)(93886004)(77156002)(62966003)(80316001)(50466002)(46102003)(66066001)(99396003)(65956001)(64126003)(101416001)(120916001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0701MB1120;H:dl.caveonetworks.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0701MB1120;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 04:52 PM, Leonid Yegoshin wrote:
> On 12/03/2014 04:20 PM, David Daney wrote:
>> On 12/03/2014 03:55 PM, Leonid Yegoshin wrote:
>>> On 12/03/2014 03:44 PM, David Daney wrote:
>>>
>>> (...)
>>>
>>> Big work
>>
>> Not really, although by number of lines of code, it is about 3x the
>> size of your patch, it only touches the existing code in one place. It
>> only took about 3 days to write, adding full MIPS64 and R6 support
>> would probably be less than another week of work.
>>
>> microMIPS I haven't looked at as we don't have anything to test it on.
>>
>>> but it doesn't support customized instructions,
>>
>> GCC will never put these in the delay slot of a FPU branch, so it is
>> not needed.
>
> I doubt that it is correct in all situations and with any GCC parameter
> combination.

My GCC experts assert that it is true.

>
> Never say never, if it is about toolchain. IMG Arch team was assured
> that branch likely are never used and removed it in MIPS R6, but BGEZL
> (or so) was a first which I hit then I ran GLIBC.

The fact that the Arch Team designed R6 without bothering to determine 
what legacy code does is not relevant to this conversation.

>
> Besides GCC there are LLVM and another JITs.
>

They don't do it either.  But that is not really important.  We can 
easily emulate faulting instructions if needed.

>>
>>> multiple ASEs,
>>
>> Same as above.  But any instructions that are deemed necessary can
>> easily be added.
>>
>>> MIPS R6
>>
>> It is a proof of concept.  R6 can easily be added if needed.
>>
>> Your XOL emulation doesn't handle R6 either, so this is no worse than
>> your patch in that respect.
>
> You probably didn't research it well. A lot of changes in
> arch/mips/kernel/branch.c and and arch/mips/math-emu/cp1emu.c, all of it
> related with R6.
>

I looked at:
commit 3a18ca061311f2f1ee9c44012f89c7436d392117

And I saw no R6 support.

Is it there, or in some other branch that isn't merged?


>>
>>> etc.
>>
>> GCC will never put trapping instructions in the delay slot either.
>
> It seems like it is not correct and requires a more accurate statement.
> FPU instructions may trap, LWL and LWR traps on R6 with RI, etc. Yes,
> there are restrictions but basing a kernel on that assumptions is
> unsafe. The only safe is HW architecture document.
>
> Finally, there is a manual encoding too.
>
>>
>> All we have to support are non-trapping and non-branch/jump
>> instructions from the ISA manuals that can be executed from userspace
>> processes. That makes it slightly simpler than complete ISA emulation.
>>
>>>
>>> Well, it is still not a replacement of XOL emulation.
>>
>> For use by the FPU emulator, it is probably good enough
>>
>>> Even close.
>>
>> I disagree, that is why I took the time to do it.
>>
>>>
>>>
>>
>

