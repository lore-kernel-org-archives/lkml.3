Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945964Ab3BHHO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:14:56 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:33925 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab3BHHOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:14:55 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: Re: [PATCH v2] fat: eliminate iterations in fat_search_long and __fat_readdir in case of EOD
References: <1359989028-7457-1-git-send-email-linkinjeon@gmail.com>
	<87bobw4ab9.fsf@devron.myhome.or.jp>
	<CAKYAXd_68nEdbdi5wEWMoavTE6kZcfwBd2Yi7jbk5nBE-_kGUw@mail.gmail.com>
Date: Fri, 08 Feb 2013 16:14:41 +0900
In-Reply-To: <CAKYAXd_68nEdbdi5wEWMoavTE6kZcfwBd2Yi7jbk5nBE-_kGUw@mail.gmail.com>
	(Namjae Jeon's message of "Fri, 8 Feb 2013 15:34:19 +0900")
Message-ID: <874nhn46qm.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> And did this work correctly about f_pos for readdir?
> Yes, sure. f_pos is work correctly about each directory entry. because
> after name[0] == 0x00, there are no allocated directory entires.
>>
>> I'm not thinking about f_pos deeply though, it may have something
>> wrong. Because it stops at middle of cluster.
> Plz See the below descirption about name[0] in FAT spec.
> ---------------------------------------------------------------------------------------------------------------------
> If DIR_Name[0] == 0x00, then the directory entry is free (same as for
> 0xE5), and there are no allocated directory entries after this one
> (all of the DIR_Name[0] bytes in all of the entries after this one are
> also set to 0).
> The special 0 value, rather than the 0xE5 value, indicates to FAT file
> system driver code that the rest of the entries in this directory do
> not need to be examined because they are all free.
> -----------------------------------------------------------------------------------------------------------------------
>
> I think that lookuping entry till the end of cluster is not needed.
> Let me know your opinion.

I know it though. There is seek() and broken drivers adds entries after
name[0] == 0. I think we don't need to care much about broken drivers
though. Even if so, kernel should not be crash, and corrupts fs more.

> And Would you tell me your opinion about fat exportfs ?

Ah, I was thinking I did. But it seems I didn't actually. Can you post
full of series? So, I can review and probably we can start to test it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
