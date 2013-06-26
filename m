Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3FZJuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:50:52 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:64375 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3FZJuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:50:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWDDCsXBK4+s4fEbM_AGj3EnfCRAe2=yE+8_MT4mauPXg@mail.gmail.com>
References: <CA+icZUWDDCsXBK4+s4fEbM_AGj3EnfCRAe2=yE+8_MT4mauPXg@mail.gmail.com>
Date: Wed, 26 Jun 2013 11:50:48 +0200
Message-ID: <CA+icZUVzsOyOdL3zRF=mikx-6vrQbZ-aKnEQTaXau+HYD0YymQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 26 [ vfs | block | fuse (cpuidle)
 releated? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:48 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Jun 26, 2013 at 10:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20130625:
>>
>> New tree: cpuinit
>>
>> The arm-mpidr tree gained a conflict against the arm tree.
>>
>> The net-next tree gained a conflict against the pm tree and a build
>> failure for which I reverted a commit.
>>
>> The drm-intel tree gained a conflict against Linus' tree.
>>
>> The pinctrl tree gained a conflict against the regmap tree.
>>
>> The akpm tree lost a patch that turned up elsewhere and gained a conflict
>> against the powerpc tree.
>>
>> The cpuinit tree lost a patch that turned up in the arc tree and gained a
>> conflict against the arm-current tree.
>>
>> ----------------------------------------------------------------------------
>>
>
> [ CC some vfs | block | fuse maintainers ]
>
> Since yesterday (next-20130625) and today (next-20130626) I can NOT
> boot into my -next kernels.
>
> I have seen two traces whereas I would like to concentrate on Trace #1.
>
> Trace #1 (noted manually, read from the screen):
> ...
> general_protection
> spin_dump
> spin_bug
> do_raw_spin_lock
> _raw_spin_locking
> rwsem_spin_locking
> rwsem_downwrite_failed
> _rwsem_downwrite_failed
> call_rwsem_downwrite_failed
> downwrite
> fuse_kill_sb_blk
> deactivate_locked_super
> mount_bdev
> fuse_iget
> fuse_mountblk
> mount_fs
> vfs_kern_mount
> do_mount
> __get_free_pages
> copy_mount_options
> SyS_mount
> tracesys
>
> Trace #2 (noted manually, read from the screen):
> ...
> blablabla cpuidle
> ...
> arch_trigger_all_cpu_backtrace_handler
>
> I have attached my kernel-config.
>
> Any hints/feedback welcome!
>

Just as a sidenote:

This is not a ***native*** Ubuntu/precise AMD64 installation - I am
using a WUBI environment.

- Sedat -

https://wiki.ubuntu.com/WubiGuide

> Regards,
> - Sedat -
