Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3A2FFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:05:55 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:49553 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3A2FFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:05:53 -0500
MIME-Version: 1.0
In-Reply-To: <87wquxpg9h.fsf@devron.myhome.or.jp>
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
	<CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
	<CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
	<87623ydnvq.fsf@devron.myhome.or.jp>
	<CAKYAXd8GgrG+cMN_wQDFLiuXoBPbR7c6N9eZqGCrK-OH3HpuZA@mail.gmail.com>
	<CAKYAXd9OhKDh5r6O=ACyDez1B2S=DB0Eo2-cSNuM1vaURmFNoQ@mail.gmail.com>
	<877gobn7fy.fsf@devron.myhome.or.jp>
	<CAKYAXd8SB7tz82Y57TKcngZC8vzvy1S=SAhzurA92jyobaVtNg@mail.gmail.com>
	<87obhnlmkt.fsf@devron.myhome.or.jp>
	<87k3sblmj2.fsf@devron.myhome.or.jp>
	<CAKYAXd-7kq9EoBE7e5sGXBeA8u914moz15-ubFimczGyiznUCA@mail.gmail.com>
	<87r4lgxgee.fsf@devron.myhome.or.jp>
	<CAKYAXd_Lg8twC3XVX8S3Ncm0ghicvXD0Q75-8amuO2Lz40v8Rw@mail.gmail.com>
	<8738xoshed.fsf@devron.myhome.or.jp>
	<CAKYAXd-pNnnDBeTw4s05vMdmeTcBwMMT7L7=NNUj2vLxwHYWWg@mail.gmail.com>
	<87wquxpg9h.fsf@devron.myhome.or.jp>
Date: Tue, 29 Jan 2013 14:05:52 +0900
Message-ID: <CAKYAXd8yvh3WZ9cT85baLJzDarccJQQi9SHSe_ErJVw8Bkf++Q@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/28, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> Although checking several routines to check hang case you said, I
>>>> didn't find anything.
>>>> And There is no any race on test result also. Am I missing something ?
>>>> Let me know your opinion.
>>>
>>> Hm, it's read-only. So, there may not be race for now, I'm sure there is
>>> race on write path though.
>> Yes, right. We checked/tested on read-only.
>> Maybe have you found race with rename and unlink ?
>> If yes, I think we can fix this issue with lock like this.
>>
>> +                       mutex_lock(&MSDOS_SB(sb)->s_lock);
>>                          parent_inode = fat_rebuild_parent(sb,
>> parent_logstart);
>> +                       mutex_unlock(&MSDOS_SB(sb)->s_lock);
>
> It is any changes to directory. ->s_lock is not preferred. We need only
> per-directory lock (i.e. dir->i_mutex).
>
> To do this, we need more bigger changes though. E.g. register temporary
> inode to central list. Then, find it when building real inode. If found
> temporary, grab it, and make update it as real inode.
>
> Yes, this is a bit complex. But we would need something like this for
> write support.

First Thanks for review and help. We will try to fix it as your
suggestion now for the Write path.
There is one suggestion. As per discussion before, your suggestion was
that, we will merge read-only support for FAT exportfs first.
And the current patch set has no issues for read-only.
So If you accept, Can I try to re-send current patch-set (read-only)
first? And we will then additionally start to fix issues related with
write path step by step.
Let me know your opinion.

Thanks OGAWA!
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
