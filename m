Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaKGQ2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:28:22 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:51875 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaKGQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:28:19 -0500
MIME-Version: 1.0
In-Reply-To: <x49y4rn29oh.fsf@segfault.boston.devel.redhat.com>
References: <cover.1415220890.git.milosz@adfin.com>
	<dcc7d998033bbd999bbd92ef9c2041bce0255a3e.1415220890.git.milosz@adfin.com>
	<x49y4rn29oh.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 7 Nov 2014 11:28:17 -0500
Message-ID: <CANP1eJG=nTB_jbOUY9nQfmsxbyAfO6KhmHm0jRVTyp09dseCxg@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] vfs: Define new syscalls preadv2,pwritev2
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 6:25 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> New syscalls that take an flag argument. This change does not add any specific
>> flags.
>>
>> Signed-off-by: Milosz Tanski <milosz@adfin.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  fs/read_write.c                   | 176 ++++++++++++++++++++++++++++++--------
>>  include/linux/compat.h            |   6 ++
>>  include/linux/syscalls.h          |   6 ++
>>  include/uapi/asm-generic/unistd.h |   6 +-
>>  mm/filemap.c                      |   5 +-
>>  5 files changed, 158 insertions(+), 41 deletions(-)
>>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 94b2d34..907735c 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -866,6 +866,8 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
>>               return -EBADF;
>>       if (!(file->f_mode & FMODE_CAN_READ))
>>               return -EINVAL;
>> +     if (flags & ~0)
>> +             return -EINVAL;
>>
>>       return do_readv_writev(READ, file, vec, vlen, pos, flags);
>>  }
>> @@ -879,21 +881,23 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
>>               return -EBADF;
>>       if (!(file->f_mode & FMODE_CAN_WRITE))
>>               return -EINVAL;
>> +     if (flags & ~0)
>> +             return -EINVAL;
>>
>>       return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
>>  }
>
> Hi, Milosz,
>
> You've checked for invalid flags for the normal system calls, but not
> for the compat variants.  Can you add that in, please?
>
> Thanks!
> Jeff

That's a good catch Jeff I'll fix this and it'll be in the next
version of the patch series.

- M



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
