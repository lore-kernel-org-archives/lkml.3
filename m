Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaFQLae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:30:34 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:52413
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752233AbaFQLac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:30:32 -0400
From: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Andrew Pinski <apinski@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 00/24] ILP32 Support in ARM64
Thread-Topic: [PATCHv2 00/24] ILP32 Support in ARM64
Thread-Index: AQHPdx4fltjAVXk9G0qpJdxvxxCbT5t0HNoAgAADL/WAASO4AIAADRiV
Date: Tue, 17 Jun 2014 11:30:29 +0000
Message-ID: <E0BB089F-96F6-47D2-AF3A-41CC0788DFB9@caviumnetworks.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <20140616170808.GA5362@arm.com>
 <6ABA4097-FE5B-4F52-A4A0-C289836919F6@caviumnetworks.com>,<20140617104338.GA21752@arm.com>
In-Reply-To: <20140617104338.GA21752@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.253.2.104]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0245702D7B
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(377454003)(164054003)(24454002)(51704005)(31966008)(76176999)(74502001)(83322001)(36756003)(76482001)(80022001)(4396001)(77982001)(93886003)(66066001)(64706001)(19580405001)(19580395003)(101416001)(85306003)(87936001)(83716003)(46102001)(20776003)(82746002)(21056001)(2656002)(81342001)(54356999)(83072002)(81542001)(92566001)(77096002)(33656002)(99396002)(74662001)(79102001)(50986999)(86362001)(92726001)(105586001)(99286002)(85852003)(95666004)(104396001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR07MB127;H:CO1PR07MB127.namprd07.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Andrew.Pinski@caviumnetworks.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Jun 17, 2014, at 3:48 AM, "Catalin Marinas" <catalin.marinas@arm.com> wrote:
> 
> On Mon, Jun 16, 2014 at 05:19:32PM +0000, Pinski, Andrew wrote:
>>>> On Jun 16, 2014, at 10:08 AM, "Catalin Marinas" <catalin.marinas@arm.com> wrote:
>>>> On Sat, May 24, 2014 at 12:01:55AM -0700, Andrew Pinski wrote:
>>>> New version of the patches with documentation, signal changes are
>>>> simplified, using less compat syscalls and splitting up the patches so
>>>> it is easier to review.  I have tested LTP on both LP64 and ILP32.
>>>> There is a few LTP failures but they are due to LTP being incorrect
>>>> (sigaction structure in glibc is not the one which is used by the
>>>> kernel)
>>> 
>>> Do you have more details about what's wrong here and where the fix
>>> should go? LTP? glibc? Kernel?
>> 
>> LTP assumes some sigaction structure is the same between userland and kernel.
>> Glibc has the correct idea of what the kernel structure will be when
>> passing to the kernel already. The fix should be done in LTP. There is
>> already code in LTP for x86 for a similar issue which we should be
>> able to advantage of. 
> 
> OK. I guess you are planning to submit the LTP patch at some point (once
> kernel and glibc changes are agreed).
> 
> Any plans for big-endian ILP32?

The support is there already and ltp results are no difference from little-endian. 

> 
>>> I'll give you more specific comments on the code in the next couple of
>>> days. But for cosmetics, please wrap the lines around 72 (or whatever)
>>> characters both in emails, commit logs and Documentation/* files (and
>>> you can drop the "Thanks" part in every commit log ;)).
> 
> I forgot to mention dropping the full stop at the end of every subject.
> 
>> Will do this with the rest of the review. 
> 
> More coding style issues: please have a look at
> Documentation/CodingStyle. While I'm not usually bothered with minor
> aspects, I would like at least some consistency for multi-line comment
> style.
> 
> Also please get the patches through checkpatch.pl (it doesn't need to be
> 100% pass but it gives some clues).

I did run them through checkpatch already. The only warnings left were over 80 column warnings. 


> 
> There are a few #defines you added without corresponding brackets (hpa
> commented on one already).

Checkpatch did not warn about these but I will fix them.

Thanks,
Andrew


> 
> -- 
> Catalin
