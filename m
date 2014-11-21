Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaKUG2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:28:24 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:27633 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaKUG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:28:23 -0500
Message-ID: <546EDB4E.90409@huawei.com>
Date: Fri, 21 Nov 2014 14:27:26 +0800
From: leizhen <thunder.leizhen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Fwd: [PATCH 1/1] init:add boot option "initramfs_packnum"
References: <1415670134-8016-1-git-send-email-thunder.leizhen@huawei.com> <546EB5A2.5050604@huawei.com> <20141121040233.GB4993@thin>
In-Reply-To: <20141121040233.GB4993@thin>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.546EDB5C.007B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: e2a414ceb8c7e13243c3b323d28fae3c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/21 12:02, Josh Triplett wrote:
> On Fri, Nov 21, 2014 at 11:46:42AM +0800, leizhen wrote:
>> During the development phase, we usually enlarge initrd-end to reserve more
>> memory than the initfs zip exactly occupied. Then we can easily add or delete
>> files in zip package, without generate fdt again and again. But unfortunately,
>> if too many zeros followed initfs zip, it will take a long time to break the
>> loop.
>>
>> while (!message && len) {
>>         ... ...
>>         if (!*buf) {
>> 		buf++;
>>                 ... ...
>>                 continue;
>>         }
>>
>> So, use the boot option "initramfs_packnum" to specify how many zip packages
>> in each initrd area. When the specified number of packages decompressed in one
>> area, immediately terminate the loop. Have no impact on current use by default.
> 
> This seems like the wrong approach to me.  Rather than changing Linux to
> ignore excess data in the initramfs, could you change your bootloader to
> pass the true length of the initramfs to Linux?  Even if you reserve
> extra space, if you know how much data you've actually included, you
> could have your bootloader pass that information to Linux.

Yes, at release time, I will do it. But during development phase, men are lazy. Please
consider the following scenario:
We have test file1 and file2, they are all too big. We base upon file1 generated fs1.cpio.gz,
and base upon file2 generated fs2.cpio.gz. We don't put file1 and file2 into one fs package,
because the uploading is very slow on simulator or emulator. Now, we should keep fdt1 and fdt2
relate to two fs packages. If there are many test files, we should keep more fdts, it's not convenient.

But with this patch, we only need keep one fdt, and get the result the same to pass the true length.

> 
> - Josh Triplett
> 
> .
> 


