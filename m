Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3GaGkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:40:20 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:60334 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3GaGkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:40:18 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130731004303.GA7118@dastard>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<20130730142820.313f1af6827276df31913106@linux-foundation.org>
	<20130731004303.GA7118@dastard>
Date: Wed, 31 Jul 2013 08:40:16 +0200
Message-ID: <CA+icZUWcCv3X6GE6kMmGKcizgfMNeUErbPW_+ihbke3UL6KD3g@mail.gmail.com>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Chinner <david@fromorbit.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 2:43 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Jul 30, 2013 at 02:28:20PM -0700, Andrew Morton wrote:
>> On Thu, 25 Jul 2013 12:50:26 -0500 Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
>>
>> > This patch series adds a kernel interface to fs/aio.c so that kernel code can
>> > issue concurrent asynchronous IO to file systems.  It adds an aio command and
>> > file system methods which specify io memory with pages instead of userspace
>> > addresses.
>> >
>> > This series was written to reduce the current overhead loop imposes by
>> > performing synchronus buffered file system IO from a kernel thread.  These
>> > patches turn loop into a light weight layer that translates bios into iocbs.
>>
>> Do you have any performance numbers?
>>

[ CC Al and Linux-next maintainer ]

The more important question how to test and then provide performance numbers.
If you give me a test-case I give you numbers!

>> Does anyone care much about loop performance?  What's the value here?
>
> Yes. Anyone using loopback devices for file-backed devices exposed
> to containers and VMs cares about the memory and CPU overhead
> the double caching the existing loop device has.
>

Yupp, I am here on Ubuntu/precise AMD64 in a so-called WUBI
environment which makes intensive usage of loopback-device plus FUSE
driver and $fs-of-your-choice (here: ext4).

Today, I have pulled Dave's aio_loop GIT branch into v3.11-rc3.
After successful compilation I am running it right now.

I had also tested v6 of the series [1] from February 2013 and
encouraged Dave to put it into Linux-next [2].
Unfortunately, there was no response from Al.
Again, Dave try to get it into Linux-next!

- Sedat -

[1] http://marc.info/?t=135947707100013&r=1&w=4
[2] http://marc.info/?l=linux-fsdevel&m=136122569807203&w=4
