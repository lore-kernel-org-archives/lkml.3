Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaE2Soh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:44:37 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62036 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaE2Sog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:44:36 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <31766.1401387746@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
	<29026.1401383705@warthog.procyon.org.uk>
	<CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com>
	<29191.1401384252@warthog.procyon.org.uk>
	<CA+icZUV64FQy4K7zx4B8NvwSXRgFfHZ_Y5D3A+zDAw9+XAwrxA@mail.gmail.com>
	<29410.1401385296@warthog.procyon.org.uk>
	<CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com>
	<31766.1401387746@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 20:44:34 +0200
Message-ID: <CA+icZUWUjkp4kpsXZg+UeW5UbWU0D_aDKzh2S9_JYeLhNaWgFg@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 8:22 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> >         TEST_OVERLAYFS=1 ./run.sh
>> >
>> > right?
>> >
>>
>> Yes (with my mount-patch applied).
>>
>> ( ...and... # umount /lower /upper /mnt )
>
> Can you put a couple of echo commands in settings.inc to show which side of
> the if-statement it goes and also put:
>
>         echo TEST_OVERLAYFS is $TEST_OVERLAYFS
>
> in run.sh and mount_union.sh?
>

I retried with the new kernel-config...

# modprobe -v overlayfs
insmod /lib/modules/3.15.0-rc7-58.1-iniza-lockdep/kernel/fs/overlayfs/overlayfs.ko

...and echo-line changes...

# LC_ALL=C TEST_OVERLAYFS="1" ./run.sh
[ run.sh ] TEST_OVERLAYFS is 1
***
*** ./run.sh open-plain.test
***
[ mount_union.sh ] TEST_OVERLAYFS is 1
TEST100: Open O_RDONLY
 - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
 - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
TEST101: Open O_WRONLY
 - open_file -w /mnt/a/foo101 -W q
/mnt/a/foo101: Test file not on upper filesystem  (line 30)

# LC_ALL=C df -h | egrep 'mnt|upper|lower'
lower_layer     1.9G  240K  1.9G   1% /lower
upper_layer     1.9G  4.0K  1.9G   1% /upper
overlayfs       1.9G  4.0K  1.9G   1% /mnt

# find /mnt/ /upper/ /lower/ -name foo101
/mnt/a/foo101
/upper/upper/a/foo101
/lower/a/foo101

# LC_ALL=C ll /mnt/a/foo101 /upper/upper/a/foo101 /lower/a/foo101
-rw-r--r-- 1 bin bin 12 May 29 20:42 /lower/a/foo101
-rw-r--r-- 1 bin bin 12 May 29 20:42 /mnt/a/foo101
-rw-r--r-- 1 bin bin 12 May 29 20:42 /upper/upper/a/foo101

# stat -c foo101 /mnt/ /upper/ /lower/
foo101
foo101
foo101

- Sedat -
