Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3A2BQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:16:32 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64221 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3A2BQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:16:30 -0500
X-AuditID: 9c930179-b7d01ae000004006-c9-510722eacbd8
Message-ID: <510722E9.5090603@lge.com>
Date: Tue, 29 Jan 2013 10:16:25 +0900
From: "kyungsik.lee" <kyungsik.lee@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org>
In-Reply-To: <20130128142510.68092e10.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-29 오전 7:25, Andrew Morton wrote:
> On Sat, 26 Jan 2013 14:50:43 +0900
> Kyungsik Lee <kyungsik.lee@lge.com> wrote:
>
>> This patchset is for supporting LZ4 compressed kernel and initial ramdisk on
>> the x86 and ARM architectures.
>>
>> According to http://code.google.com/p/lz4/, LZ4 is a very fast lossless
>> compression algorithm and also features an extremely fast decoder.
>>
>> Kernel Decompression APIs are based on implementation by Yann Collet
>> (http://code.google.com/p/lz4/source/checkout).
>> De/compression Tools are also provided from the site above.
>>
>> The initial test result on ARM(v7) based board shows that the size of kernel
>> with LZ4 compressed is 8% bigger than LZO compressed  but the decompressing
>> speed is faster(especially under the enabled unaligned memory access).
>>
>> Test: 3.4 based kernel built with many modules
>> Uncompressed kernel size: 13MB
>> lzo: 6.3MB, 301ms
>> lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)
>>
>> It seems that it___s worth trying LZ4 compressed kernel image or ramdisk
>> for making the kernel boot more faster.
>>
>> ...
>>
>>   20 files changed, 663 insertions(+), 3 deletions(-)
>>
>> ...
>>
> What's this "with enabled unaligned memory access" thing?  You mean "if
> the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
> that's only x86, which isn't really in the target market for this
> patch, yes?

Yes, exactly. If the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,

then it is expected more boot-time improvement by LZ4-decompressor.

Currently there are two architectures which support it in mainline; x86 and powerpc.
And it is expected that ARM arch(v6 or above) also support it since the commit below.
Commit ID: 5010192d5
ARM: 7583/1: decompressor: Enable unaligned memory access for v6 and above
by Dave Martin

The test results(167ms) come from the ARM(v7 arch), MSM8960 based board with
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS set.
  

>
> It's a lot of code for a 50ms boot-time improvement.  Does anyone have
> any opinions on whether or not the benefits are worth the cost?
>

Not only for the kernel but also the ramdisk can be compressed with LZ4 so
the boot-time would be more improved. The test case above didn't include
the decompressing time result for LZ4-compressed ramdisk.

So far the implementation is applicable to boot-time improvement for
LZ4-compressed kernel and ramdisk images but the decompressor module is
exported as an interface for other usages like LZO.
With LZ4 compressor(not yet implemented for the kernel), it is expected
that it will be used in many places in kernel such as crypto and fs(squashfs, btrfs).

Thanks,
Kyungsik

  




