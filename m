Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab3FFNFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:05:03 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57223 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3FFNFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:05:01 -0400
MIME-Version: 1.0
In-Reply-To: <51B03FB0.80306@cn.fujitsu.com>
References: <1370071212-7715-1-git-send-email-linkinjeon@gmail.com>
	<51AD698F.3020305@cn.fujitsu.com>
	<CAKYAXd_jFuG00-HWQREKieXdqBGEAs+W0imvYZjCpGAH5S4H9A@mail.gmail.com>
	<51B03FB0.80306@cn.fujitsu.com>
Date: Thu, 6 Jun 2013 22:05:00 +0900
Message-ID: <CAKYAXd9_jPS4vBMb+jdQBxQ76Q875zio+uMb7uGTgz4N=jxQzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] f2fs: add remount_fs callback support
From: Namjae Jeon <linkinjeon@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
>>
>>>
>>>> +
>>>> +     /**
>>>> +      * We stop the GC thread if FS is mounted as RO
>>>> +      * or if background_gc = 0 is passed in mount
>>>> +      * option. Also sync the filesystem.
>>>> +      */
>>>> +     if ((*flags & MS_RDONLY) || !test_opt(sbi, BG_GC)) {
>>>
>>>
>>> Another condition: The old mount is not RO.
>> I don't think that it is needed. I think current condition check can
>> be covered about all cases.
>> Am I missing something ?
>
Hi Gu.
> Maybe. If the old mount is RO, so does the remount. It still can pass the judgement here, right?
> Though the following stop_gc_thread() and f2fs_sync_fs() can handle this case well, but this
> is unnecessary and needless. If we add additional judgement of whether old mount is not RO can avoid this.
>
Okay, I understand.
I will update it on v2 patch.

Thanks~.
> Thanks,
> Gu
>
>>
>>>
