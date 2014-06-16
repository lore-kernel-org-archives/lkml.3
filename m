Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaFPRTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:19:36 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:34682
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755659AbaFPRTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:19:35 -0400
From: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Pinski <apinski@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 00/24] ILP32 Support in ARM64
Thread-Topic: [PATCHv2 00/24] ILP32 Support in ARM64
Thread-Index: AQHPdx4fltjAVXk9G0qpJdxvxxCbT5t0HNoAgAADL/U=
Date: Mon, 16 Jun 2014 17:19:32 +0000
Message-ID: <6ABA4097-FE5B-4F52-A4A0-C289836919F6@caviumnetworks.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>,<20140616170808.GA5362@arm.com>
In-Reply-To: <20140616170808.GA5362@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.253.2.104]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0244637DEA
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(164054003)(51704005)(24454002)(189002)(199002)(377454003)(33656002)(87936001)(46102001)(105586001)(76482001)(101416001)(21056001)(86362001)(83716003)(77982001)(82746002)(99286001)(77096002)(4396001)(2656002)(85852003)(74662001)(92726001)(79102001)(83322001)(19580395003)(19580405001)(81342001)(80022001)(66066001)(20776003)(54356999)(76176999)(31966008)(92566001)(74502001)(64706001)(81542001)(99396002)(83072002)(50986999)(85306003)(36756003)(104396001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR07MB128;H:CO1PR07MB127.namprd07.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Andrew.Pinski@caviumnetworks.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Jun 16, 2014, at 10:08 AM, "Catalin Marinas" <catalin.marinas@arm.com> wrote:
> 
> Andrew,
> 
>> On Sat, May 24, 2014 at 12:01:55AM -0700, Andrew Pinski wrote:
>> New version of the patches with documentation, signal changes are
>> simplified, using less compat syscalls and splitting up the patches so
>> it is easier to review.  I have tested LTP on both LP64 and ILP32.
>> There is a few LTP failures but they are due to LTP being incorrect
>> (sigaction structure in glibc is not the one which is used by the
>> kernel)
> 
> Do you have more details about what's wrong here and where the fix
> should go? LTP? glibc? Kernel?

LTP assumes some sigaction structure is the same between userland and kernel.
Glibc has the correct idea of what the kernel structure will be when passing to the kernel already. The fix should be done in LTP. There is already code in LTP for x86 for a similar issue which we should be able to advantage of. 

> 
> I'll give you more specific comments on the code in the next couple of
> days. But for cosmetics, please wrap the lines around 72 (or whatever)
> characters both in emails, commit logs and Documentation/* files (and
> you can drop the "Thanks" part in every commit log ;)).

Will do this with the rest of the review. 

> 
>> Andrew Pinski (24):
>>  ARM64: Force LP64 to compile the kernel.
>>  ARM64: Rename COMPAT to AARCH32_EL0 in Kconfig.
>>  ARM64: Change some CONFIG_COMPAT over to use CONFIG_AARCH32_EL0
>>    instead.
>>  ARM64:ILP32: Set kernel_long to long long so we can reuse most of the
>>    same syscalls as LP64.
>>  ARM64:UAPI: Set the correct __BITS_PER_LONG for ILP32.
>>  Allow for some signal structures to be the same between a 32bit ABI
>>    and the 64bit ABI.
>>  ARM64:ILP32: Use the same size and layout of the signal structures
>>    for ILP32 as for LP64.
>>  Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to
>>    avoid confusion of not splitting the registers.
>>  ARM64:ILP32: Use the same syscall names as LP64.
>>  ARM64: Introduce is_a32_task and is_a32_thread. Use them in the
>>    correct locations.
>>  ARM64: Add ARM64_ILP32 to Kconfig.
> 
> Does this patch need to be in the middle of the series? It should come
> after the ILP32 support is complete.


Ok, I will move it. I had added in the middle to test the newly added code. 

Thanks,
Andrew

> 
> Thanks.
> 
> -- 
> Catalin
