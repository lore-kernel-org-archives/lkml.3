Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab3APQdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:33:07 -0500
Received: from mx2.parallels.com ([64.131.90.16]:56293 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab3APQdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:33:02 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@zabbo.net>, Maxim Patlasov <MPatlasov@parallels.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
Thread-Topic: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
Thread-Index: AQHN9AckBU/BbJkf9Eempikh7KsAyw==
Date: Wed, 16 Jan 2013 16:32:58 +0000
Message-ID: <1358353978.2384.50.camel@dabdike.int.hansenpartnership.com>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [46.65.52.191]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <4CCA67A75E8D94428CB64A9ED0BC0C1C@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 13:58 -0600, Dave Kleikamp wrote:
> This patchset was begun by Zach Brown and was originally submitted for
> review in October, 2009. Feedback was positive, and I have picked up
> where he left off, porting his patches to the latest mainline kernel
> and adding support more file systems.
> 
> This patch series adds a kernel interface to fs/aio.c so that kernel code can
> issue concurrent asynchronous IO to file systems.  It adds an aio command and
> file system methods which specify io memory with pages instead of userspace
> addresses.
> 
> This series was written to reduce the current overhead loop imposes by
> performing synchronus buffered file system IO from a kernel thread.  These
> patches turn loop into a light weight layer that translates bios into iocbs.
> 
> It introduces new file ops, read_iter() and write_iter(), that replace the
> aio_read() and aio_write() operations. The iov_iter structure can now contain
> either a user-space iovec or a kernel-space bio_vec. Since it would be
> overly complicated to replace every instance of aio_read() and aio_write(),
> the old operations are not removed, but file systems implementing the new
> ones need not keep the old ones.
> 
> Changes from V4 include:
>  * moved iov-iter.c from mm/ to fs/
>  * removed dio_aligned helper
>  * insured that FUA write to loop device is committed to media
>  * removed no-longer-used REQ_KERNEL define
> 
> These patches apply to 3.8-rc2 and are also available at:
> git://github.com/kleikamp/linux-shaggy.git loop_2013_01_04
> 
> My hopes are that this patchset is finally ready for linux-next.

Just a note that we at parallels are anxiously awaiting this too.  Our
rewrite of the linux loop device to be more efficient (and not double
cache) depends on this work.  I should also note that we've been testing
these patches (albeit backported to a RHEL kernel as a current work
base) with no problems reported so far.

James

