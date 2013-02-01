Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3BAHBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:01:03 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60613 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3BAHBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:01:00 -0500
X-AuditID: 9c930179-b7c24ae00000119c-d7-510b6829b1fb
Message-ID: <510B6829.7050908@lge.com>
Date: Fri, 01 Feb 2013 16:00:57 +0900
From: "kyungsik.lee" <kyungsik.lee@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rajesh Pawar <pawaraj@india.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-kbuild@jasper.es, linux-arm-kernel@lists.infradead.org,
        David Sterba <dsterba@suse.cz>,
        =?UTF-8?B?7J6E7Zqo7KSA?= <hyojun.im@lge.com>,
        =?UTF-8?B?7KCV7LCs6reg?= <chan.jeong@lge.com>, minchan@kernel.org,
        =?UTF-8?B?6rmA64Ko7ZiV?= <namhyung.kim@lge.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Egon Alter <egon.alter@gmx.net>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        markus@oberhumer.com, raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>, <20130128142510.68092e10.akpm@linux-foundation.org> <254788880.18003.1359493798737.JavaMail.tomcat@be12>
In-Reply-To: <254788880.18003.1359493798737.JavaMail.tomcat@be12>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-30 오전 6:09, Rajesh Pawar wrote:
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Sat, 26 Jan 2013 14:50:43 +0900
>> Kyungsik Lee <kyungsik.lee@lge.com> wrote:
>>> This patchset is for supporting LZ4 compressed kernel and initial ramdisk on
>>> the x86 and ARM architectures.
>>>
>>> According to [[http://code.google.com/p/lz4/,]] LZ4 is a very fast lossless
>>> compression algorithm and also features an extremely fast decoder.
>>>
>>> Kernel Decompression APIs are based on implementation by Yann Collet
>>> ([[http://code.google.com/p/lz4/source/checkout]]).
>>> De/compression Tools are also provided from the site above.
>>>
>>> The initial test result on ARM(v7) based board shows that the size of kernel
>>> with LZ4 compressed is 8% bigger than LZO compressed but the decompressing
>>> speed is faster(especially under the enabled unaligned memory access).
>>>
>>> Test: 3.4 based kernel built with many modules
>>> Uncompressed kernel size: 13MB
>>> lzo: 6.3MB, 301ms
>>> lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)
>>>
>>> It seems that it___s worth trying LZ4 compressed kernel image or ramdisk
>>> for making the kernel boot more faster.
>>>
>>> ...
>>>
>>> 20 files changed, 663 insertions(+), 3 deletions(-)
>>>
>>> ...
>>>
>> What's this "with enabled unaligned memory access" thing? You mean "if
>> the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"? If so,
>> that's only x86, which isn't really in the target market for this
>> patch, yes?
>> It's a lot of code for a 50ms boot-time improvement. Does anyone have
>> any opinions on whether or not the benefits are worth the cost?
> BTW, what happened to the proposed LZO update - woudn't it better to merge this first?
>
> Also, under the hood LZ4 seems to be quite similar to LZO, so probably
> LZO speed would also greatly benefit from unaligned access and some other
> ARM optimisations
>   
I didn't test with the proposed LZO update you mentioned. Sorry, which 
one do you mean?
I did some tests with the latest LZO in the mainline.

As a result, LZO is not faster in an unaligned access enabled on ARM. 
Actually Slower.

Decompression time: 336ms(383ms, with unaligned access enabled)

You may refer to https://lkml.org/lkml/2012/10/7/85 to know more about it.

Thanks,
Kyungsik


Thanks,
Kyungsik
