Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaDYIid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:38:33 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:5465
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522AbaDYIiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:38:00 -0400
From: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
To: Chung-Lin Tang <cltang@codesourcery.com>
CC: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>,
        "Tang, Chung-Lin" <ChungLin_Tang@mentor.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
Thread-Topic: [PATCH 00/28] nios2 Linux kernel port
Thread-Index: AQHPXx3VtXWNi/pT6kai6tyZi4xMSJsfgc3vgADMOQCAACmbgIAAbcaAgAA0z4CAAAFjXIAAvwcAgAAqdKk=
Date: Fri, 25 Apr 2014 08:37:57 +0000
Message-ID: <9F7B4786-D935-47E3-9AB0-258E2A6EB98F@caviumnetworks.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <5354AD36.5090809@zytor.com>
 <CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>
 <16597012.pEkDc99HDN@wuerfel>
 <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
 <5357FF8E.9010809@codesourcery.com>
 <E780DB23-B6A3-427B-8F33-71378088A3F5@caviumnetworks.com>
 <5358AE96.9010006@codesourcery.com> <5358D17D.1040609@codesourcery.com>
 <20140424152819.GI8521@arm.com>,<535959DF.6050009@codesourcery.com>
 <3AD1421B-E5FC-41F3-AE33-29655052DA4B@caviumnetworks.com>,<5359FB48.1020007@codesourcery.com>
In-Reply-To: <5359FB48.1020007@codesourcery.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.253.2.104]
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(24454002)(51704005)(189002)(199002)(377454003)(479174003)(164054003)(87936001)(83072002)(82746002)(33656001)(46102001)(2656002)(36756003)(76482001)(50986999)(76176999)(4396001)(99396002)(83716003)(80976001)(99286001)(86362001)(80022001)(19580395003)(83322001)(19580405001)(81542001)(81342001)(79102001)(66066001)(20776003)(31966008)(74502001)(85852003)(92726001)(54356999)(92566001)(77982001)(74662001)(100906001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB125;H:CO1PR07MB127.namprd07.prod.outlook.com;FPR:B2FBF0DD.AFF292D5.FDFBB17A.49E5C5C1.20570;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Apr 24, 2014, at 11:06 PM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
> 
>> On 2014/4/25 02:42 AM, Pinski, Andrew wrote:
>> 
>> 
>>>> On Apr 24, 2014, at 11:37 AM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
>>>> 
>>>>> On 2014/4/24 11:28 PM, Catalin Marinas wrote:
>>>>>> On Thu, Apr 24, 2014 at 09:55:25AM +0100, Chung-Lin Tang wrote:
>>>>>>> On 2014/4/24 02:26 PM, Chung-Lin Tang wrote:
>>>>>>> On 2014/4/24 上午 02:15, Pinski, Andrew wrote:
>>>>>>> 
>>>>>>>>> On Apr 23, 2014, at 10:59 AM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
>>>>>>>>> 
>>>>>>>>>>> On 2014/4/22 07:20 PM, Ley Foon Tan wrote:
>>>>>>>>>>> On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>>>>>>>>>>>> On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>>>>>>>>>>>>>>>>>>> Hi Arnd and Peter Anvin,
>>>>>>>>>>>>>>>>>>> 
>>>>>>>>>>>>>>>>>>> Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
>>>>>>>>>>>>>>>>>>> that we don't need to have 64 bit off_t? See detail in link below.
>>>>>>>>>>>>>>>>>>> I can submit the patches for 64-bit time changes
>>>>>>>>>>>>>>>>>>> (include/asm-generic/posix_types.h and other archs) if everyone is
>>>>>>>>>>>>>>>>>>> agreed on this.
>>>>>>>>>>>>>>> 
>>>>>>>>>>>>>>> Yes.
>>>>>>>>>>> Okay, will doing that.
>>>>>>>>> 
>>>>>>>>> I believe that arm64 ILP32 will also be affected. What is the status of
>>>>>>>>> this configuration? Has the glibc/kernel ABI been finalized?
>>>>>>> Not yet.  I am still working out the signal handling part. But we
>>>>>>> already agreed on 64bit time_t, clock_t, and suseconds_t.  And we
>>>>>>> agreed to a 64bit offset_t too. 
>>>>>>> 
>>>>>>> On a related note suseconds in the timespec in posix is defined to
>>>>>>> be long. So it would nice if the kernel ignores the upper 32bits so
>>>>>>> we (glibc developers) can fix this for new targets including x32
>>>>>>> and arm64/ilp32.
>>>>>> 
>>>>>> Hmm, but that means for purely 32-bit architectures like nios2, which
>>>>>> unlike x86_64 or arm64, never has a 64-bit mode, suseconds_t as a 64-bit
>>>>>> type in the kernel is simply wasted.
>>>>> 
>>>>> The more I think of this, the more I feel that suseconds_t should jsut
>>>>> be 'long', not strictly 64-bitified. An ILP32 sub-mode in a 64-bit
>>>>> kernel should be using compat_* code paths, something like a
>>>>> COMPAT_USE_32BIT_SUSECONDS case.
>>>> 
>>>> ILP32 mode should use LP64 syscalls as much as possible and that's the
>>>> aim with arm64 as well (of course, we still have a few that wouldn't be
>>>> possible and we route them via compat).
>>>> 
>>>> But here if time_t is 64-bit while susecconds_t is 32-bit, the compat
>>>> code wouldn't help.
>>> 
>>> Why not? You can define the arm64 'struct compat_timeval' with
>>> suseconds_t as s32, and add the 32<-->64 case in the
>>> compat_get/put_timeval path, triggered when the process is ILP32 (test
>>> wrapped in the above hypothetical COMPAT_USE_32BIT_SUSECONDS macro).
>>> Similar to how x32 does COMPAT_USE_64BIT_TIME.
>> 
>> We would three timeval then. One for aarch32, one for lp64 and one for ilp32. We really don't want three. Two is already one too many in my mind after developing the ilp32 syscall abi. 
>> 
>> Thanks,
>> Andrew
> 
> Okay I now see you're already doing that for 32-bit ARM.
> 
> Still, you would probably just need to have an arm64-ILP32 specific case
> to be careful about the last padding word upon kernel entry/exit.
> (accommodating the difference in sizeof(long))  Penalizing all
> architectures does not seem like the best solution.

Considering the alignment of long long would be 64bits, the struct does not change sizes if suseconds_t is 32bits or 64bits. 

> 
> Having suseconds_t as a strictly 64-bit C type in the kernel, while
> defined as <= long in user-space may cause other problems.
> 
> I'll try to explain a probable situation for Nios II. I'm not sure about
> other soft-cores, but nios2 is sort of uncommon in that the maximum
> alignment is 4-bytes (32-bits), even for doubles/long-longs.

Yes does that include even if users of aligned?  If so that seems broken.  Also yes nios ii is unstandard when it comes to alignment here. 

> 
> So if time_t is 64-bits (which makes sense), then struct timeval, which
> is time_t+suseconds_t in userspace is 12-bytes/aligned-4 (unlike many
> archs where a 64-bit time_t will expand the size to 16-bytes, due to
> align-8)

Unlike most other targets where the struct would 16bits no matter what. 

Thanks,
Andrew


> 
> If the kernel suseconds_t is forced to be 64-bits, then nios2 will have
> a 16-byte kernel timeval vs. 12-byte userspace timeval situation. Just
> this will require us to do something using compat_*, or weird hacks in
> glibc, which is unfair. Nios II has no "other-mode". We are just
> strictly ILP32, everywhere.
> 
> Of course, we can probably still at the end just use a Nios II specific
> posix_types.h header to override things, but I'm just stating this as a
> matter of which are the most reasonable default settings in the generic
> headers. Making pure ILP32 archs diverge from POSIX standards by default
> does not seem to be right.
> 
> Thanks,
> Chung-Lin
> 
