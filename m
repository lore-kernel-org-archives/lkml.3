Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbaFTFHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:07:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39508 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaFTFHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:07:19 -0400
Message-ID: <53A3C177.1000905@zytor.com>
Date: Thu, 19 Jun 2014 22:07:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] initramfs: Support initrd that is bigger then 2G.
References: <1403230336-10444-1-git-send-email-yinghai@kernel.org>	<53A3B8B7.70806@zytor.com> <CAE9FiQXRWR8vWFZEsuoGMbe1mZL72QWyjWfNt13o0+Q9bgHJfg@mail.gmail.com>
In-Reply-To: <CAE9FiQXRWR8vWFZEsuoGMbe1mZL72QWyjWfNt13o0+Q9bgHJfg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 10:02 PM, Yinghai Lu wrote:
> On Thu, Jun 19, 2014 at 9:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/19/2014 07:12 PM, Yinghai Lu wrote:
>>>
>>> Also need to use that in write_buffer path for cpio that have file is
>>> more than file.
>>
>> That sentence doesn't make sense.
> 
> I mean this path:
>    unpack_to_rootfs  ===> write_buffer ===> actions[].../do_copy
> and image is uncompressed cpio, and there is one big file (>2G) in that cpio.

Don't tell me, make the description clear so someone can understand it
10 years from now.
>>
>> It would be nice in order to support very large initrd/initramfs, to
>> free the memory as it becomes available instead of requiring two copies
>> of the data in memory at the same time.
> 
> for initramfs, it is from ramdisk_image/ramdisk_size to tmpfs directly.
> and ramdisk_image/ramdisk_size get freed.
> 
> for initrd, it is transferred to /initrd.image in tmpfs at first, and
> ramdisk_image/ramdisk_size
> get freed,  at last /initrd.image is decompressed/copied to /dev/ram0
> and get removed
> from tempfs.
> 
> So what do you mean "free the memory"?
> 

For each of those transfers, we don't free the source memory until the
very end.  We could free that memory as we process the input, requiring
less total memory.

	-hpa


