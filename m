Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab3APSZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:25:38 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:43117 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3APSZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:25:36 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1358353978.2384.50.camel@dabdike.int.hansenpartnership.com>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
	<1358353978.2384.50.camel@dabdike.int.hansenpartnership.com>
Date: Wed, 16 Jan 2013 19:25:35 +0100
Message-ID: <CA+icZUWc_hwX6A3YjD3p66FG4Qbgraukm+0GJXUPzPOWb=twJQ@mail.gmail.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
From: Sedat Dilek <sedat.dilek@gmail.com>
To: James Bottomley <jbottomley@parallels.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@zabbo.net>, Maxim Patlasov <MPatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 5:32 PM, James Bottomley
<jbottomley@parallels.com> wrote:
> On Wed, 2013-01-09 at 13:58 -0600, Dave Kleikamp wrote:
>> This patchset was begun by Zach Brown and was originally submitted for
>> review in October, 2009. Feedback was positive, and I have picked up
>> where he left off, porting his patches to the latest mainline kernel
>> and adding support more file systems.
>>
>> This patch series adds a kernel interface to fs/aio.c so that kernel code can
>> issue concurrent asynchronous IO to file systems.  It adds an aio command and
>> file system methods which specify io memory with pages instead of userspace
>> addresses.
>>
>> This series was written to reduce the current overhead loop imposes by
>> performing synchronus buffered file system IO from a kernel thread.  These
>> patches turn loop into a light weight layer that translates bios into iocbs.
>>
>> It introduces new file ops, read_iter() and write_iter(), that replace the
>> aio_read() and aio_write() operations. The iov_iter structure can now contain
>> either a user-space iovec or a kernel-space bio_vec. Since it would be
>> overly complicated to replace every instance of aio_read() and aio_write(),
>> the old operations are not removed, but file systems implementing the new
>> ones need not keep the old ones.
>>
>> Changes from V4 include:
>>  * moved iov-iter.c from mm/ to fs/
>>  * removed dio_aligned helper
>>  * insured that FUA write to loop device is committed to media
>>  * removed no-longer-used REQ_KERNEL define
>>
>> These patches apply to 3.8-rc2 and are also available at:
>> git://github.com/kleikamp/linux-shaggy.git loop_2013_01_04
>>
>> My hopes are that this patchset is finally ready for linux-next.
>
> Just a note that we at parallels are anxiously awaiting this too.  Our
> rewrite of the linux loop device to be more efficient (and not double
> cache) depends on this work.  I should also note that we've been testing
> these patches (albeit backported to a RHEL kernel as a current work
> base) with no problems reported so far.
>

Hi James,

do you have a location for me for testing this patchset from parallels?

Regards,
- Sedat -

> James
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
