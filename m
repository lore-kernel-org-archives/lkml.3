Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaJGQEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:04:54 -0400
Received: from [157.56.111.67] ([157.56.111.67]:38176 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754303AbaJGQEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:04:53 -0400
Message-ID: <54340F14.6030809@caviumnetworks.com>
Date: Tue, 7 Oct 2014 09:04:36 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Fortune <Matthew.Fortune@imgtec.com>
CC: David Daney <david.s.daney@gmail.com>, Rich Felker <dalias@libc.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
In-Reply-To: <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BY2PR07CA020.namprd07.prod.outlook.com (10.255.247.45) To
 CO2PR07MB585.namprd07.prod.outlook.com (10.141.229.146)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR07MB585;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(199003)(377454003)(479174003)(24454002)(83506001)(120916001)(50466002)(80316001)(46102003)(92566001)(21056001)(80022003)(69596002)(110136001)(99136001)(4396001)(99396003)(65816999)(76482002)(50986999)(122386002)(23756003)(87266999)(66066001)(85852003)(54356999)(64126003)(92726001)(33656002)(107046002)(42186005)(95666004)(101416001)(106356001)(64706001)(47776003)(102836001)(53416004)(20776003)(81156004)(31966008)(59896002)(65806001)(77096002)(105586002)(93886004)(76176999)(87976001)(36756003)(85306004)(97736003)(40100002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB585;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 02:13 AM, Matthew Fortune wrote:
>>>> the out-of-line execution trick, but do it somewhere other than in
>>>> stack memory.
>>> How do you answer Andy Lutomirski's question about what happens when a
>>> signal handler interrupts execution while the program counter is
>>> pointing at this "out-of-line execution" trampoline? This seems like a
>>> show-stopper for using anything other than the stack.
>> It would be nice to support, but not doing so would not be a regression
>> from current behavior.
>
> It seems appropriate to mention another issue which should be addressed as
> part of the overall FPU emulation work...
>
>  From what I can see the out-of-line execution of delay slot instructions
> will break micromips R3 addiupc, and all MIPS32r6 and MIPS64r6 PC-relative
> instructions (inc load/store) as they will have the wrong base. Is there
> anything in the current set of proposals that can address this (beyond
> adding restrictions to what is ABI allowed in FPU branch delay slots)?
>
> This is an issue whether the stack is executable or not but does directly
> relate to the topic of FPU emulation.  It sounds like the kernel would not
> be able to emulate a pc-relative load/store even if it was a special case
> as it would not run in the correct MM context? [be gentle, I'm no expert
> in this area].
>

I haven't studied the r6 ISA in depth.  But you are correct, the r6 ISA 
cannot be supported with the eXecute-Out-of-Line tricks due to the PC 
relative instructions.

So probably the best path forward is to abandon the current method, and 
bite the bullet and write an entire instruction set emulator.  It 
doesn't have to be fast.

David Daney


> Matthew
>

