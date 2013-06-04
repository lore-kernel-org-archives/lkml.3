Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3FDEYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:24:01 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33912 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3FDEX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <1370312366.3600.3.camel@kjgkr>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
	<1370312366.3600.3.camel@kjgkr>
Date: Tue, 4 Jun 2013 13:23:57 +0900
Message-ID: <CAKYAXd-87rGatnEC8wbocR_wt6Qdpec3HzZaH9ukpzmst6DK=A@mail.gmail.com>
Subject: Re: [RFC 0/5] Enable f2fs support inline data
From: Namjae Jeon <linkinjeon@gmail.com>
To: Huajun Li <huajun.li@intel.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com, namjae.jeon@samsung.com,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Huajun.

I agree jaegeuk's opinion.
Additionally, It is better that you describe the effect in change-log
when this feature is added to f2fs.
e.g.
    1. how much space is saved when storing kernel-tree(small files) ?
    2. small files creation performance test.
    3. file look-up performance test.
    4. other performance tools 's result.

Thanks.

2013/6/4 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
>
> This feature is one of my todo items. ;)
> Thank you for the contribution.
>
> Before reviewing the below code intensively, we need to check the
> following issues.
>
> - deadlock conditions
> - FS consistency
> - recovery routine
>
> Could you check one more time?
> Thanks again,
>
> 2013-06-03 (월), 18:04 +0800, Huajun Li:
>> f2fs inode is so large, small files can be stored directly in the inode,
>> rather than just storing a single block address and storing the data elsewhere.
>>
>> This RFC patch set is just to enable f2fs support inline data: files less than
>> about 3.6K can be stored directly in inode block.
>>
>> TODO: make small dirs inline too.
>>
>>
>> Haicheng Li (3):
>>   f2fs: Add helper functions and flag to support inline data
>>   f2fs: Add interface for inline data support
>>   f2fs: add tracepoints to debug inline data operations
>>
>> Huajun Li (2):
>>   f2fs: Handle inline data read and write
>>   f2fs: Key functions to handle inline data
>>
>>  fs/f2fs/Kconfig             |   10 +++
>>  fs/f2fs/Makefile            |    1 +
>>  fs/f2fs/data.c              |   78 +++++++++++++++++++++-
>>  fs/f2fs/f2fs.h              |   70 +++++++++++++++++++
>>  fs/f2fs/file.c              |    9 ++-
>>  fs/f2fs/inline.c            |  156 +++++++++++++++++++++++++++++++++++++++++++
>>  fs/f2fs/inode.c             |    8 +++
>>  include/linux/f2fs_fs.h     |    5 ++
>>  include/trace/events/f2fs.h |   69 +++++++++++++++++++
>>  9 files changed, 402 insertions(+), 4 deletions(-)
>>  create mode 100644 fs/f2fs/inline.c
>>
>
> --
> Jaegeuk Kim
> Samsung
