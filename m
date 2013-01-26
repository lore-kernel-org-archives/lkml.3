Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3AZEWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 23:22:13 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57171 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3AZEWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 23:22:09 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if fat_dget() fails
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
Date: Sat, 26 Jan 2013 13:22:02 +0900
In-Reply-To: <CAKYAXd_Lg8twC3XVX8S3Ncm0ghicvXD0Q75-8amuO2Lz40v8Rw@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 22 Jan 2013 19:31:45 +0900")
Message-ID: <8738xoshed.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2013/1/20, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>> We rewrite patch as your suggestion using dummy inode. Would please
>>> you review below patch code ?
>>
>> Looks like good as initial. Clean and shorter.
>>
>> Next is, we have to think about race. I.e. if real inode was made, what
>> happens? Is there no race?
> Hi OGAWA.
>
> Although checking several routines to check hang case you said, I
> didn't find anything.
> And There is no any race on test result also. Am I missing something ?
> Let me know your opinion.

Hm, it's read-only. So, there may not be race for now, I'm sure there is
race on write path though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
