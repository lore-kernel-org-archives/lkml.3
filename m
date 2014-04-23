Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaDWSaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:30:35 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:20518
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753564AbaDWSac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:30:32 -0400
X-Greylist: delayed 895 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2014 14:30:32 EDT
From: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
To: Chung-Lin Tang <cltang@codesourcery.com>
CC: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Catalin.Marinas@arm.com" <Catalin.Marinas@arm.com>,
        Andrew Pinski <apinski@cavium.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
Thread-Topic: [PATCH 00/28] nios2 Linux kernel port
Thread-Index: AQHPXx3VtXWNi/pT6kai6tyZi4xMSJsfgc3v
Date: Wed, 23 Apr 2014 18:15:34 +0000
Message-ID: <E780DB23-B6A3-427B-8F33-71378088A3F5@caviumnetworks.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<5354AD36.5090809@zytor.com>
	<CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>
	<16597012.pEkDc99HDN@wuerfel>
 <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>,<5357FF8E.9010809@codesourcery.com>
In-Reply-To: <5357FF8E.9010809@codesourcery.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.2.3.195]
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(377454003)(479174003)(164054003)(24454002)(189002)(199002)(51704005)(99286001)(99396002)(4396001)(83716003)(80976001)(54356999)(50986999)(76176999)(79102001)(92726001)(85852003)(92566001)(77982001)(66066001)(80022001)(20776003)(74502001)(74662001)(31966008)(86362001)(19580395003)(19580405001)(83322001)(81342001)(81542001)(36756003)(46102001)(33656001)(87936001)(2656002)(83072002)(82746002)(76482001)(100906001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB125;H:CO1PR07MB127.namprd07.prod.outlook.com;FPR:B642FCE3.AFF2A845.7DFB336E.EBD551.2021E;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Apr 23, 2014, at 10:59 AM, "Chung-Lin Tang" <cltang@codesourcery.com> wrote:
> 
>> On 2014/4/22 07:20 PM, Ley Foon Tan wrote:
>> On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>>>>>> Hi Arnd and Peter Anvin,
>>>>>> 
>>>>>> Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
>>>>>> that we don't need to have 64 bit off_t? See detail in link below.
>>>>>> I can submit the patches for 64-bit time changes
>>>>>> (include/asm-generic/posix_types.h and other archs) if everyone is
>>>>>> agreed on this.
>>>> 
>>>> Yes.
>> Okay, will doing that.
> 
> I believe that arm64 ILP32 will also be affected. What is the status of
> this configuration? Has the glibc/kernel ABI been finalized?

Not yet.  I am still working out the signal handling part. But we already agreed on 64bit time_t, clock_t, and suseconds_t.  And we agreed to a 64bit offset_t too. 

On a related note suseconds in the timespec in posix is defined to be long. So it would nice if the kernel ignores the upper 32bits so we (glibc developers) can fix this for new targets including x32 and arm64/ilp32. 

Thanks,
Andrew

> 
> Thanks,
> Chung-Lin
> 
