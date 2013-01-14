Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3ANFrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:47:46 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:57165 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3ANFro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:47:44 -0500
MIME-Version: 1.0
In-Reply-To: <1358126915.22868.18.camel@kjgkr>
References: <1357969308-9361-1-git-send-email-linkinjeon@gmail.com>
	<1358126915.22868.18.camel@kjgkr>
Date: Mon, 14 Jan 2013 14:47:43 +0900
Message-ID: <CAKYAXd-48BxygiLq+e5sP2VK0SB722EUj6HLwByz19Pmbvu6dw@mail.gmail.com>
Subject: Re: [PATCH 3/4] f2fs: introduce trace points in f2fs filesystem
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/14, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-01-12 (토), 14:41 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> #> cat /sys/kernel/debug/tracing/events/f2fs/enable
>> 0
>> #> echo 1 > /sys/kernel/debug/tracing/events/f2fs/enable
>> #> cat /sys/kernel/debug/tracing/events/f2fs/enable
>> 1
>>
>> #> mount -t f2fs /dev/sdb3  /mnt/
>> #>
>> #> cat /sys/kernel/debug/tracing/trace
>> # tracer: nop
>> #
>> #TASK-PID    CPU#    TIMESTAMP  FUNCTION
>> #   | |       |          |         |
>>  mount-423   [001]    49.879188: f2fs_iget: dev 8,19 ino 2
>>  mount-423   [001]    49.879215: f2fs_get_page: dev 8,19  page_index 81,
>> type 2
>>  mount-423   [001]    49.879224: f2fs_readpage: dev 8,19 ino 2 page_index
>> 81
>>  mount-423   [001]    49.879819: f2fs_get_page: dev 8,19  page_index 83,
>> type 2
>>  mount-423   [001]    49.879830: f2fs_readpage: dev 8,19 ino 2 page_index
>> 83
>>  mount-423   [001]    49.880434: f2fs_get_page: dev 8,19  page_index 593,
>> type 2
>>  mount-423   [001]    49.880442: f2fs_readpage: dev 8,19 ino 2 page_index
>> 593
>>  mount-423   [001]    49.889931: f2fs_get_page: dev 8,19  page_index 595,
>> type 2
>>  mount-423   [001]    49.889939: f2fs_readpage: dev 8,19 ino 2 page_index
>> 595
>>  mount-423   [001]    49.892169: f2fs_get_page: dev 8,19  page_index 594,
>> type 2
>>  mount-423   [001]    49.892186: f2fs_readpage: dev 8,19 ino 2 page_index
>> 594
>>  ...
>>  ..
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
>> ---
>>  fs/f2fs/checkpoint.c        |   17 +
>>  fs/f2fs/data.c              |   17 +
>>  fs/f2fs/file.c              |   14 +
>>  fs/f2fs/inode.c             |   10 +
>>  fs/f2fs/namei.c             |    7 +-
>>  fs/f2fs/node.c              |   23 +-
>>  fs/f2fs/segment.c           |    5 +
>>  fs/f2fs/super.c             |    4 +
>>  include/trace/events/f2fs.h | 1220
>> +++++++++++++++++++++++++++++++++++++++++++
>
> IMO, it needs to split this patch into two independent patches like:
> 1. adding a header file to the event subsystem, and
> 2. introducing tracepoints in f2fs.
>
> Then, we need to get acks from all the related maintainers.
>
> Moreover, it is obvious that the patch-set should describe each of
> tracepoints precisely and concretely.
>
> Anyway, it must be a valuable job. :)
> Thanks,
Hi Jaegeuk.
Okay, I see. I will split the patch as your suggestion.
And I will check more performance side and the reason why we should
add trace point here.

Thanks.
>
> --
> Jaegeuk Kim
> Samsung
>
