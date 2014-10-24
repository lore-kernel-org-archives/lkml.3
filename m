Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaJXQ7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:59:14 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51762 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaJXQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:59:11 -0400
MIME-Version: 1.0
In-Reply-To: <x49a94lpkma.fsf@segfault.boston.devel.redhat.com>
References: <cover.1413923420.git.milosz@adfin.com>
	<9306856a3ea74bcc41523430d74ef4be93d8f436.1413923420.git.milosz@adfin.com>
	<x49a94lpkma.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 24 Oct 2014 12:59:09 -0400
Message-ID: <CANP1eJHqtpYttwmzhW2K7rN91fc_sxiLOGn56VrWyjEEc8HVtQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] vfs: Prepare for adding a new preadv/pwritev with
 user flags.
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:12 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> Plumbing the flags argument through the vfs code so they can be passed down to
>> __generic_file_(read/write)_iter function that do the acctual work.
>                                                         ^^^^^^^
> actual
>
>> Signed-off-by: Milosz Tanski <milosz@adfin.com>
>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 7d9318c..9858c06 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
> [...]
>> @@ -1113,6 +1116,7 @@ COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
>>       return __compat_sys_preadv64(fd, vec, vlen, pos);
>>  }
>>
>> +
>>  static size_t compat_writev(struct file *file,
>>                           const struct compat_iovec __user *vec,
>>                           unsigned long vlen, loff_t *pos)
>
> Lose this hunk.
>
>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 14b4642..cb7f530 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1465,7 +1465,7 @@ static void shrink_readahead_size_eio(struct file *filp,
>>   * of the logic when it comes to error handling etc.
>>   */
>>  static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
>> -             struct iov_iter *iter, ssize_t written)
>> +             struct iov_iter *iter, ssize_t written, int flags)
>>  {
>>       struct address_space *mapping = filp->f_mapping;
>>       struct inode *inode = mapping->host;
>
> As Christoph mentioned, this belongs elsewhere.
>
> Fix that up and you an add my:
>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

I have addresses both these issues and they'll be in the next submission.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
