Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab3BHGeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:34:22 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:56874 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3BHGeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <87bobw4ab9.fsf@devron.myhome.or.jp>
References: <1359989028-7457-1-git-send-email-linkinjeon@gmail.com>
	<87bobw4ab9.fsf@devron.myhome.or.jp>
Date: Fri, 8 Feb 2013 15:34:19 +0900
Message-ID: <CAKYAXd_68nEdbdi5wEWMoavTE6kZcfwBd2Yi7jbk5nBE-_kGUw@mail.gmail.com>
Subject: Re: [PATCH v2] fat: eliminate iterations in fat_search_long and
 __fat_readdir in case of EOD
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> When doing lookups via fat_search_long(), we can stop checking for
>> further entries if we detect End of Directory, i.e. if (de->name[0] ==
>> 0x00).The current code traverses the cluster chain of a directory until a
>> hit
>> is found or till the last cluster for that directory, ignoring the EOD
>> mark. Fix this.
>>
>> Likewise,when readdir(3) is called, we can stop checking for further
>> entries in __fat_readdir() when we hit EOD.
>
Hi OGAWA.
> Don't we need to change fat_get_short_entry()?
Yes, We need to change here. Thanks for review!

> And did this work correctly about f_pos for readdir?
Yes, sure. f_pos is work correctly about each directory entry. because
after name[0] == 0x00, there are no allocated directory entires.
>
> I'm not thinking about f_pos deeply though, it may have something
> wrong. Because it stops at middle of cluster.
Plz See the below descirption about name[0] in FAT spec.
---------------------------------------------------------------------------------------------------------------------
If DIR_Name[0] == 0x00, then the directory entry is free (same as for
0xE5), and there are no allocated directory entries after this one
(all of the DIR_Name[0] bytes in all of the entries after this one are
also set to 0).
The special 0 value, rather than the 0xE5 value, indicates to FAT file
system driver code that the rest of the entries in this directory do
not need to be examined because they are all free.
-----------------------------------------------------------------------------------------------------------------------

I think that lookuping entry till the end of cluster is not needed.
Let me know your opinion.

And Would you tell me your opinion about fat exportfs ?
Thanks!
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
