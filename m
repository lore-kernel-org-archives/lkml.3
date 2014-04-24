Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaDXSmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:42:23 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:33229
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932206AbaDXSmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:42:21 -0400
From: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
To: Chung-Lin Tang <cltang@codesourcery.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Ley Foon Tan <lftan@altera.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>,
        "Tang, Chung-Lin" <ChungLin_Tang@mentor.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
Thread-Topic: [PATCH 00/28] nios2 Linux kernel port
Thread-Index: AQHPXx3VtXWNi/pT6kai6tyZi4xMSJsfgc3vgADMOQCAACmbgIAAbcaAgAA0z4CAAAFjXA==
Date: Thu, 24 Apr 2014 18:42:16 +0000
Message-ID: <3AD1421B-E5FC-41F3-AE33-29655052DA4B@caviumnetworks.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <5354AD36.5090809@zytor.com>
 <CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>
 <16597012.pEkDc99HDN@wuerfel>
 <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
 <5357FF8E.9010809@codesourcery.com>
 <E780DB23-B6A3-427B-8F33-71378088A3F5@caviumnetworks.com>
 <5358AE96.9010006@codesourcery.com> <5358D17D.1040609@codesourcery.com>
 <20140424152819.GI8521@arm.com>,<535959DF.6050009@codesourcery.com>
In-Reply-To: <535959DF.6050009@codesourcery.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.2.3.195]
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(164054003)(377454003)(24454002)(479174003)(51704005)(199002)(189002)(76176999)(4396001)(86362001)(46102001)(80976001)(99286001)(2656002)(81542001)(19580395003)(87936001)(20776003)(99396002)(76482001)(83322001)(50986999)(19580405001)(54356999)(77982001)(82746002)(85852003)(36756003)(92726001)(79102001)(92566001)(81342001)(33656001)(83072002)(83716003)(74502001)(31966008)(74662001)(66066001)(80022001)(100906001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB126;H:CO1PR07MB127.namprd07.prod.outlook.com;FPR:B274F0DE.AE229B05.7DFBB37A.49E6C5D3.203C5;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Apr 24, 2014, at 11:37 AM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
> 
>> On 2014/4/24 11:28 PM, Catalin Marinas wrote:
>>> On Thu, Apr 24, 2014 at 09:55:25AM +0100, Chung-Lin Tang wrote:
>>>> On 2014/4/24 02:26 PM, Chung-Lin Tang wrote:
>>>>> On 2014/4/24 上午 02:15, Pinski, Andrew wrote:
>>>>> 
>>>>>>> On Apr 23, 2014, at 10:59 AM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
>>>>>>> 
>>>>>>>>> On 2014/4/22 07:20 PM, Ley Foon Tan wrote:
>>>>>>>>> On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>>>>>>>>>> On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>>>>>>>>>>>>>>>>> Hi Arnd and Peter Anvin,
>>>>>>>>>>>>>>>>> 
>>>>>>>>>>>>>>>>> Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
>>>>>>>>>>>>>>>>> that we don't need to have 64 bit off_t? See detail in link below.
>>>>>>>>>>>>>>>>> I can submit the patches for 64-bit time changes
>>>>>>>>>>>>>>>>> (include/asm-generic/posix_types.h and other archs) if everyone is
>>>>>>>>>>>>>>>>> agreed on this.
>>>>>>>>>>>>> 
>>>>>>>>>>>>> Yes.
>>>>>>>>> Okay, will doing that.
>>>>>>> 
>>>>>>> I believe that arm64 ILP32 will also be affected. What is the status of
>>>>>>> this configuration? Has the glibc/kernel ABI been finalized?
>>>>> Not yet.  I am still working out the signal handling part. But we
>>>>> already agreed on 64bit time_t, clock_t, and suseconds_t.  And we
>>>>> agreed to a 64bit offset_t too. 
>>>>> 
>>>>> On a related note suseconds in the timespec in posix is defined to
>>>>> be long. So it would nice if the kernel ignores the upper 32bits so
>>>>> we (glibc developers) can fix this for new targets including x32
>>>>> and arm64/ilp32.
>>>> 
>>>> Hmm, but that means for purely 32-bit architectures like nios2, which
>>>> unlike x86_64 or arm64, never has a 64-bit mode, suseconds_t as a 64-bit
>>>> type in the kernel is simply wasted.
>>> 
>>> The more I think of this, the more I feel that suseconds_t should jsut
>>> be 'long', not strictly 64-bitified. An ILP32 sub-mode in a 64-bit
>>> kernel should be using compat_* code paths, something like a
>>> COMPAT_USE_32BIT_SUSECONDS case.
>> 
>> ILP32 mode should use LP64 syscalls as much as possible and that's the
>> aim with arm64 as well (of course, we still have a few that wouldn't be
>> possible and we route them via compat).
>> 
>> But here if time_t is 64-bit while susecconds_t is 32-bit, the compat
>> code wouldn't help.
> 
> Why not? You can define the arm64 'struct compat_timeval' with
> suseconds_t as s32, and add the 32<-->64 case in the
> compat_get/put_timeval path, triggered when the process is ILP32 (test
> wrapped in the above hypothetical COMPAT_USE_32BIT_SUSECONDS macro).
> Similar to how x32 does COMPAT_USE_64BIT_TIME.

We would three timeval then. One for aarch32, one for lp64 and one for ilp32. We really don't want three. Two is already one too many in my mind after developing the ilp32 syscall abi. 

Thanks,
Andrew


> 
> Chung-Lin
> 
> 
> 
> 
> 
