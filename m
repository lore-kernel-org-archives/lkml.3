Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaE2T26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:28:58 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:61713 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaE2T24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:28:56 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <9971.1401391507@warthog.procyon.org.uk>
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
	<CA+icZUWUjkp4kpsXZg+UeW5UbWU0D_aDKzh2S9_JYeLhNaWgFg@mail.gmail.com>
	<9971.1401391507@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 21:28:53 +0200
Message-ID: <CA+icZUVsFnXRragfSg0gyyLP2PsfQnRir2pL9eYFkH4Oo3+a6Q@mail.gmail.com>
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

On Thu, May 29, 2014 at 9:25 PM, David Howells <dhowells@redhat.com> wrote:
>
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> # LC_ALL=C TEST_OVERLAYFS="1" ./run.sh
>> [ run.sh ] TEST_OVERLAYFS is 1
>> ***
>> *** ./run.sh open-plain.test
>> ***
>> [ mount_union.sh ] TEST_OVERLAYFS is 1
>> TEST100: Open O_RDONLY
>>  - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
>>  - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
>> TEST101: Open O_WRONLY
>>  - open_file -w /mnt/a/foo101 -W q
>> /mnt/a/foo101: Test file not on upper filesystem  (line 30)
>
> This looks like the setting up worked.  Can you cat /proc/mounts?
>

# cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=1965028k,nr_inodes=491257,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=393632k,mode=755 0 0
/dev/sda2 /host fuseblk
rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other,blksize=4096
0 0
/dev/loop0 / ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
none /sys/fs/fuse/connections fusectl rw,relatime 0 0
none /sys/kernel/debug debugfs rw,relatime 0 0
none /sys/kernel/security securityfs rw,relatime 0 0
none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
gvfs-fuse-daemon /home/wearefam/.gvfs fuse.gvfs-fuse-daemon
rw,nosuid,nodev,relatime,user_id=1000,group_id=1000 0 0
lower_layer /lower tmpfs ro,relatime 0 0
upper_layer /upper tmpfs rw,relatime 0 0
overlayfs /mnt overlayfs
rw,relatime,lowerdir=/lower,upperdir=/upper/upper,workdir=/upper/work
0 0


...and see a lockdep...

[   90.360420] =============================================
[   90.360421] [ INFO: possible recursive locking detected ]
[   90.360424] 3.15.0-rc7-58.2-iniza-lockdep #1 Not tainted
[   90.360425] ---------------------------------------------
[   90.360426] open-file/2896 is trying to acquire lock:
[   90.360428]  (&sb->s_type->i_mutex_key#10/2){+.+.+.}, at:
[<ffffffff811fc325>] generic_file_splice_write+0xa5/0x1b0
[   90.360440]
[   90.360440] but task is already holding lock:
[   90.360441]  (&sb->s_type->i_mutex_key#10/2){+.+.+.}, at:
[<ffffffff811d7b54>] lock_rename+0x104/0x110
[   90.360448]
[   90.360448] other info that might help us debug this:
[   90.360450]  Possible unsafe locking scenario:
[   90.360450]
[   90.360451]        CPU0
[   90.360452]        ----
[   90.360453]   lock(&sb->s_type->i_mutex_key#10/2);
[   90.360456]   lock(&sb->s_type->i_mutex_key#10/2);
[   90.360458]
[   90.360458]  *** DEADLOCK ***
[   90.360458]
[   90.360460]  May be due to missing lock nesting notation
[   90.360460]
[   90.360462] 4 locks held by open-file/2896:
[   90.360463]  #0:  (sb_writers#4){.+.+.+}, at: [<ffffffff811eeac4>]
mnt_want_write+0x24/0x50
[   90.360469]  #1:  (&type->s_vfs_rename_key){+.+.+.}, at:
[<ffffffff811d7a83>] lock_rename+0x33/0x110
[   90.360473]  #2:  (&sb->s_type->i_mutex_key#9/1){+.+.+.}, at:
[<ffffffff811d7b3e>] lock_rename+0xee/0x110
[   90.360479]  #3:  (&sb->s_type->i_mutex_key#10/2){+.+.+.}, at:
[<ffffffff811d7b54>] lock_rename+0x104/0x110
[   90.360484]
[   90.360484] stack backtrace:
[   90.360487] CPU: 3 PID: 2896 Comm: open-file Not tainted
3.15.0-rc7-58.2-iniza-lockdep #1
[   90.360489] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
[   90.360491]  ffffffff82305750 ffff880055ee97b0 ffffffff8172d4fc
ffff880119740d30
[   90.360494]  ffff880055ee9868 ffffffff810be698 ffff880055ee97f0
ffff880055ee9870
[   90.360497]  0000001000000000 0000000000000000 2412950908a5652b
0000000000000000
[   90.360500] Call Trace:
[   90.360504]  [<ffffffff8172d4fc>] dump_stack+0x4d/0x66
[   90.360508]  [<ffffffff810be698>] __lock_acquire+0x1ae8/0x1b60
[   90.360512]  [<ffffffff810bc5ea>] ? mark_held_locks+0x6a/0x90
[   90.360514]  [<ffffffff810c1bf1>] ? __raw_spin_lock_init+0x21/0x60
[   90.360517]  [<ffffffff810babfc>] ? lockdep_init_map+0x9c/0x4a0
[   90.360520]  [<ffffffff810beec9>] lock_acquire+0x99/0x120
[   90.360523]  [<ffffffff811fc325>] ? generic_file_splice_write+0xa5/0x1b0
[   90.360527]  [<ffffffff81735d7b>] mutex_lock_nested+0x6b/0x4d0
[   90.360529]  [<ffffffff811fc325>] ? generic_file_splice_write+0xa5/0x1b0
[   90.360532]  [<ffffffff811fc325>] generic_file_splice_write+0xa5/0x1b0
[   90.360535]  [<ffffffff811fbc76>] direct_splice_actor+0x36/0x40
[   90.360537]  [<ffffffff811fc573>] splice_direct_to_actor+0xc3/0x1e0
[   90.360540]  [<ffffffff811fbc40>] ? splice_from_pipe_begin+0x20/0x20
[   90.360543]  [<ffffffff811fc70c>] do_splice_direct+0x7c/0xb0
[   90.360547]  [<ffffffffa03e54cd>] ovl_copy_up_one+0x5cd/0x730 [overlayfs]
[   90.360551]  [<ffffffffa03e5709>] ovl_copy_up+0xd9/0x110 [overlayfs]
[   90.360554]  [<ffffffffa03e24f8>] ovl_dentry_open+0xc8/0xf0 [overlayfs]
[   90.360558]  [<ffffffff811ca749>] vfs_open+0x29/0x50
[   90.360561]  [<ffffffff811d9422>] do_last+0x672/0x1390
[   90.360564]  [<ffffffff811daf71>] ? link_path_walk+0x71/0x890
[   90.360567]  [<ffffffff811dbcd5>] ? path_init+0x545/0x6a0
[   90.360570]  [<ffffffff810bc700>] ? trace_hardirqs_on_caller+0xf0/0x1c0
[   90.360573]  [<ffffffff811dce88>] ? path_openat+0x78/0x680
[   90.360575]  [<ffffffff811dcecb>] path_openat+0xbb/0x680
[   90.360579]  [<ffffffff811de51a>] do_filp_open+0x3a/0x90
[   90.360582]  [<ffffffff81739de7>] ? _raw_spin_unlock+0x27/0x40
[   90.360585]  [<ffffffff811ec277>] ? __alloc_fd+0xa7/0x130
[   90.360588]  [<ffffffff811cc0a8>] do_sys_open+0x128/0x220
[   90.360592]  [<ffffffff81022805>] ? syscall_trace_enter+0x145/0x260
[   90.360595]  [<ffffffff811cc1be>] SyS_open+0x1e/0x20
[   90.360598]  [<ffffffff81743d98>] tracesys+0xe1/0xe6

- Sedat -
