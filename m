Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3ARX25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:28:57 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56397 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3ARX24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:28:56 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <7232571.q75lsg8Tuc@vostro.rjw.lan>
References: <CA+icZUW-mfMtNSY-d-=0WpX=fRBqoNx5jcX3S8x4tvGdvUc+8g@mail.gmail.com>
	<CA+icZUUTkr2wxu6qMJNxMNsWpJzubwCGFF80h0sc2B+qiATNNA@mail.gmail.com>
	<CA+icZUVSNm=-LWCTm-AV+rL67V6sG9k0c6sAv8=19BmWBimyxg@mail.gmail.com>
	<7232571.q75lsg8Tuc@vostro.rjw.lan>
Date: Sat, 19 Jan 2013 00:28:55 +0100
Message-ID: <CA+icZUXvbN=ZTfcPttMKCgbbAdzxxGhKWbVTyiHKOSFfwAo92Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 18 [ BROKEN suspend: jbd2|acpi|pm? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 12:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, January 18, 2013 11:56:53 PM Sedat Dilek wrote:
>> On Fri, Jan 18, 2013 at 11:35 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > On Fri, Jan 18, 2013 at 11:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> On Friday, January 18, 2013 11:11:07 PM Sedat Dilek wrote:
>> >>> On Fri, Jan 18, 2013 at 5:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >>> > Hi all,
>> >>> >
>> >>> > Changes since 20130117:
>> >>> >
>> >>> > Undropped tree: samung
>> >>> >
>> >>> > The powerpc tree still had a build failure.
>> >>> >
>> >>> > The driver-core tree gained a build failure for which I applied a merge
>> >>> > fix patch.
>> >>> >
>> >>> > The gpio-lw tree gained a build failure so I used the version from
>> >>> > next-20130117.
>> >>> >
>> >>> > The samsung tree lost the majority of its conflicts but gained more
>> >>> > against the arm-soc and slave-dma tree.
>> >>> >
>> >>> > ----------------------------------------------------------------------------
>> >>> >
>> >>>
>> >>> From my dmesg diff-file:
>> >>>
>> >>> +[  288.730849] PM: Syncing filesystems ... done.
>> >>> +[  294.050498] Freezing user space processes ... (elapsed 0.04 seconds) done.
>> >>> +[  294.097024] Freezing remaining freezable tasks ...
>> >>> +[  314.098849] Freezing of tasks failed after 20.01 seconds (1 tasks
>> >>> refusing to freeze, wq_busy=0):
>> >>> +[  314.098862] jbd2/loop0-8    D ffffffff8180d780     0   297      2 0x00000000
>> >>> +[  314.098865]  ffff880117ec5b68 0000000000000046 ffff880117ec5b08
>> >>> ffffffff81044c29
>> >>> +[  314.098868]  ffff88011829dc80 ffff880117ec5fd8 ffff880117ec5fd8
>> >>> ffff880117ec5fd8
>> >>> +[  314.098871]  ffff880119b34560 ffff88011829dc80 ffff880117ec5b68
>> >>> ffff88011fad4738
>> >>> +[  314.098873] Call Trace:
>> >>> +[  314.098881]  [<ffffffff81044c29>] ? default_spin_lock_flags+0x9/0x10
>> >>> +[  314.098885]  [<ffffffff811c63e0>] ? __wait_on_buffer+0x30/0x30
>> >>> +[  314.098888]  [<ffffffff816b4b59>] schedule+0x29/0x70
>> >>> +[  314.098890]  [<ffffffff816b4c2f>] io_schedule+0x8f/0xd0
>> >>> +[  314.098892]  [<ffffffff811c63ee>] sleep_on_buffer+0xe/0x20
>> >>> +[  314.098896]  [<ffffffff816b342f>] __wait_on_bit+0x5f/0x90
>> >>> +[  314.098898]  [<ffffffff811c5aa1>] ? submit_bh+0x121/0x1e0
>> >>> +[  314.098900]  [<ffffffff811c63e0>] ? __wait_on_buffer+0x30/0x30
>> >>> +[  314.098903]  [<ffffffff816b34dc>] out_of_line_wait_on_bit+0x7c/0x90
>> >>> +[  314.098906]  [<ffffffff8107eb00>] ? autoremove_wake_function+0x40/0x40
>> >>> +[  314.098909]  [<ffffffff811c63de>] __wait_on_buffer+0x2e/0x30
>> >>> +[  314.098913]  [<ffffffff8128a6a1>]
>> >>> jbd2_journal_commit_transaction+0x1791/0x1960
>> >>> +[  314.098917]  [<ffffffff8109269d>] ? sched_clock_cpu+0xbd/0x110
>> >>> +[  314.098920]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
>> >>> +[  314.098923]  [<ffffffff81069fbf>] ? try_to_del_timer_sync+0x4f/0x70
>> >>> +[  314.098925]  [<ffffffff8128e4e8>] kjournald2+0xb8/0x240
>> >>> +[  314.098927]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
>> >>> +[  314.098929]  [<ffffffff8128e430>] ? commit_timeout+0x10/0x10
>> >>> +[  314.098931]  [<ffffffff8107ded0>] kthread+0xc0/0xd0
>> >>> +[  314.098933]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
>> >>> +[  314.098936]  [<ffffffff816be52c>] ret_from_fork+0x7c/0xb0
>> >>> +[  314.098938]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
>> >>> +[  314.098969]
>> >>> +[  314.098970] Restarting kernel threads ... done.
>> >>> +[  314.099052] Restarting tasks ... done.
>> >>>
>> >>> Please, have a lot at it.
>> >>
>> >> This is a freezer failure while freezing kernel threads, so I don't think it's
>> >> related to ACPI or PM directly.
>> >>
>> >> Does it happen on every suspend?
>> >>
>> >
>> > No, I only did one S/R.
>> >
>> > I have built a 2nd new kernel where I pulled-in latest pm.git#linux-next.
>> > With this kernel two S/Rs were fine - but that says not much.
>> >
>>
>> After several S/Rs on the "buggy" -1 kernel I know see in my syslogs:
>>
>> Jan 18 23:50:02 fambox kernel: [  141.853828] Disabling non-boot CPUs ...
>> Jan 18 23:50:02 fambox kernel: [  141.956943] smpboot: CPU 1 is now offline
>> Jan 18 23:50:02 fambox kernel: [  141.957438] NOHZ: local_softirq_pending 02
>> Jan 18 23:50:02 fambox kernel: [  141.957454] NOHZ: local_softirq_pending 02
>> Jan 18 23:50:02 fambox kernel: [  142.060830] smpboot: CPU 2 is now offline
>> Jan 18 23:50:02 fambox kernel: [  142.164639] smpboot: CPU 3 is now offline
>
> Are you worried about the "local_softirq_pending" messages?
>

That's the only new messages I have seen after several S/Rs.
If you have a testcase for me to reproduce it here, I would be happy.

- Sedat -

> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
