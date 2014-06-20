Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbaFTFCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:02:54 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51101 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933794AbaFTFCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <53A3B8B7.70806@zytor.com>
References: <1403230336-10444-1-git-send-email-yinghai@kernel.org>
	<53A3B8B7.70806@zytor.com>
Date: Thu, 19 Jun 2014 22:02:52 -0700
X-Google-Sender-Auth: 5gHILcqo1Wp91Z45Dar0NHojhOc
Message-ID: <CAE9FiQXRWR8vWFZEsuoGMbe1mZL72QWyjWfNt13o0+Q9bgHJfg@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Support initrd that is bigger then 2G.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 9:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/19/2014 07:12 PM, Yinghai Lu wrote:
>>
>> Also need to use that in write_buffer path for cpio that have file is
>> more than file.
>
> That sentence doesn't make sense.

I mean this path:
   unpack_to_rootfs  ===> write_buffer ===> actions[].../do_copy
and image is uncompressed cpio, and there is one big file (>2G) in that cpio.


>
>
> I would call this function xwrite(), which is usually called in userspace.

Good, will change that.

>
> It would be nice in order to support very large initrd/initramfs, to
> free the memory as it becomes available instead of requiring two copies
> of the data in memory at the same time.

for initramfs, it is from ramdisk_image/ramdisk_size to tmpfs directly.
and ramdisk_image/ramdisk_size get freed.

for initrd, it is transferred to /initrd.image in tmpfs at first, and
ramdisk_image/ramdisk_size
get freed,  at last /initrd.image is decompressed/copied to /dev/ram0
and get removed
from tempfs.

So what do you mean "free the memory"?

Thanks

Yinghai
