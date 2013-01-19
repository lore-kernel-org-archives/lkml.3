Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3ASCN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 21:13:56 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:32971 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3ASCNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 21:13:53 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVJujqWdXP7tM5CBRT53Mx7ycOJPfQqXs-wbRebcrP9pQ@mail.gmail.com>
References: <CA+icZUW-mfMtNSY-d-=0WpX=fRBqoNx5jcX3S8x4tvGdvUc+8g@mail.gmail.com>
	<2890633.q9n75klkI9@vostro.rjw.lan>
	<CA+icZUVz7UPX0n=f85e=dcAMY6rgZZqj-7CqW7t4Zdtu9nPuBA@mail.gmail.com>
	<1922388.1PvyliEuQR@vostro.rjw.lan>
	<CA+icZUVJujqWdXP7tM5CBRT53Mx7ycOJPfQqXs-wbRebcrP9pQ@mail.gmail.com>
Date: Sat, 19 Jan 2013 03:13:51 +0100
Message-ID: <CA+icZUWG8R93c485zyURzat1BP+f-T0qQmKKXD9N_in1ahwZvQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 18 [ BROKEN suspend: jbd2|acpi|pm? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, alan@lxorguk.ukuu.org.uk,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 2:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sat, Jan 19, 2013 at 12:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Saturday, January 19, 2013 12:41:11 AM Sedat Dilek wrote:
>>> On Sat, Jan 19, 2013 at 12:39 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > On Saturday, January 19, 2013 12:28:55 AM Sedat Dilek wrote:
>>> >> On Sat, Jan 19, 2013 at 12:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> >> > On Friday, January 18, 2013 11:56:53 PM Sedat Dilek wrote:
>>> >> >> On Fri, Jan 18, 2013 at 11:35 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> >> >> > On Fri, Jan 18, 2013 at 11:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> >> >> >> On Friday, January 18, 2013 11:11:07 PM Sedat Dilek wrote:
>>> >> >> >>> On Fri, Jan 18, 2013 at 5:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> >> >> >>> > Hi all,
>>> >> >> >>> >
>>> >> >> >>> > Changes since 20130117:
>>> >> >> >>> >
>>> >> >> >>> > Undropped tree: samung
>>> >> >> >>> >
>>> >> >> >>> > The powerpc tree still had a build failure.
>>> >> >> >>> >
>>> >> >> >>> > The driver-core tree gained a build failure for which I applied a merge
>>> >> >> >>> > fix patch.
>>> >> >> >>> >
>>> >> >> >>> > The gpio-lw tree gained a build failure so I used the version from
>>> >> >> >>> > next-20130117.
>>> >> >> >>> >
>>> >> >> >>> > The samsung tree lost the majority of its conflicts but gained more
>>> >> >> >>> > against the arm-soc and slave-dma tree.
>>> >> >> >>> >
>>> >> >> >>> > ----------------------------------------------------------------------------
>>> >> >> >>> >
>>> >> >> >>>
>>> >> >> >>> From my dmesg diff-file:
>>> >> >> >>>
>>> >> >> >>> +[  288.730849] PM: Syncing filesystems ... done.
>>> >> >> >>> +[  294.050498] Freezing user space processes ... (elapsed 0.04 seconds) done.
>>> >> >> >>> +[  294.097024] Freezing remaining freezable tasks ...
>>> >> >> >>> +[  314.098849] Freezing of tasks failed after 20.01 seconds (1 tasks
>>> >> >> >>> refusing to freeze, wq_busy=0):
>>> >> >> >>> +[  314.098862] jbd2/loop0-8    D ffffffff8180d780     0   297      2 0x00000000
>>> >> >> >>> +[  314.098865]  ffff880117ec5b68 0000000000000046 ffff880117ec5b08
>>> >> >> >>> ffffffff81044c29
>>> >> >> >>> +[  314.098868]  ffff88011829dc80 ffff880117ec5fd8 ffff880117ec5fd8
>>> >> >> >>> ffff880117ec5fd8
>>> >> >> >>> +[  314.098871]  ffff880119b34560 ffff88011829dc80 ffff880117ec5b68
>>> >> >> >>> ffff88011fad4738
>>> >> >> >>> +[  314.098873] Call Trace:
>>> >> >> >>> +[  314.098881]  [<ffffffff81044c29>] ? default_spin_lock_flags+0x9/0x10
>>> >> >> >>> +[  314.098885]  [<ffffffff811c63e0>] ? __wait_on_buffer+0x30/0x30
>>> >> >> >>> +[  314.098888]  [<ffffffff816b4b59>] schedule+0x29/0x70
>>> >> >> >>> +[  314.098890]  [<ffffffff816b4c2f>] io_schedule+0x8f/0xd0
>>> >> >> >>> +[  314.098892]  [<ffffffff811c63ee>] sleep_on_buffer+0xe/0x20
>>> >> >> >>> +[  314.098896]  [<ffffffff816b342f>] __wait_on_bit+0x5f/0x90
>>> >> >> >>> +[  314.098898]  [<ffffffff811c5aa1>] ? submit_bh+0x121/0x1e0
>>> >> >> >>> +[  314.098900]  [<ffffffff811c63e0>] ? __wait_on_buffer+0x30/0x30
>>> >> >> >>> +[  314.098903]  [<ffffffff816b34dc>] out_of_line_wait_on_bit+0x7c/0x90
>>> >> >> >>> +[  314.098906]  [<ffffffff8107eb00>] ? autoremove_wake_function+0x40/0x40
>>> >> >> >>> +[  314.098909]  [<ffffffff811c63de>] __wait_on_buffer+0x2e/0x30
>>> >> >> >>> +[  314.098913]  [<ffffffff8128a6a1>]
>>> >> >> >>> jbd2_journal_commit_transaction+0x1791/0x1960
>>> >> >> >>> +[  314.098917]  [<ffffffff8109269d>] ? sched_clock_cpu+0xbd/0x110
>>> >> >> >>> +[  314.098920]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
>>> >> >> >>> +[  314.098923]  [<ffffffff81069fbf>] ? try_to_del_timer_sync+0x4f/0x70
>>> >> >> >>> +[  314.098925]  [<ffffffff8128e4e8>] kjournald2+0xb8/0x240
>>> >> >> >>> +[  314.098927]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
>>> >> >> >>> +[  314.098929]  [<ffffffff8128e430>] ? commit_timeout+0x10/0x10
>>> >> >> >>> +[  314.098931]  [<ffffffff8107ded0>] kthread+0xc0/0xd0
>>> >> >> >>> +[  314.098933]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
>>> >> >> >>> +[  314.098936]  [<ffffffff816be52c>] ret_from_fork+0x7c/0xb0
>>> >> >> >>> +[  314.098938]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
>>> >> >> >>> +[  314.098969]
>>> >> >> >>> +[  314.098970] Restarting kernel threads ... done.
>>> >> >> >>> +[  314.099052] Restarting tasks ... done.
>>> >> >> >>>
>>> >> >> >>> Please, have a lot at it.
>>> >> >> >>
>>> >> >> >> This is a freezer failure while freezing kernel threads, so I don't think it's
>>> >> >> >> related to ACPI or PM directly.
>>> >> >> >>
>>> >> >> >> Does it happen on every suspend?
>>> >> >> >>
>>> >> >> >
>>> >> >> > No, I only did one S/R.
>>> >> >> >
>>> >> >> > I have built a 2nd new kernel where I pulled-in latest pm.git#linux-next.
>>> >> >> > With this kernel two S/Rs were fine - but that says not much.
>>> >> >> >
>>> >> >>
>>> >> >> After several S/Rs on the "buggy" -1 kernel I know see in my syslogs:
>>> >> >>
>>> >> >> Jan 18 23:50:02 fambox kernel: [  141.853828] Disabling non-boot CPUs ...
>>> >> >> Jan 18 23:50:02 fambox kernel: [  141.956943] smpboot: CPU 1 is now offline
>>> >> >> Jan 18 23:50:02 fambox kernel: [  141.957438] NOHZ: local_softirq_pending 02
>>> >> >> Jan 18 23:50:02 fambox kernel: [  141.957454] NOHZ: local_softirq_pending 02
>>> >> >> Jan 18 23:50:02 fambox kernel: [  142.060830] smpboot: CPU 2 is now offline
>>> >> >> Jan 18 23:50:02 fambox kernel: [  142.164639] smpboot: CPU 3 is now offline
>>> >> >
>>> >> > Are you worried about the "local_softirq_pending" messages?
>>> >> >
>>> >>
>>> >> That's the only new messages I have seen after several S/Rs.
>>> >
>>> > They are kind of unusual.
>>> >
>>> > Anyway, they seem to be related to CPU hotplug (CPU offline), so you can try
>>> > if you can trigger them through the sysfs CPU offline/online interface.
>>> >
>>>
>>> Can you explain that a bit clearer or give some sample lines for testing?
>>
>> There is a sysfs file
>>
>> /sys/devices/system/cpu/cpuX/online
>>
>> (where X=0,1,2,3,...) for each CPU core in the system.  The value read from it
>> indicates whether or not the given core is online (1 means online).  Writing 0
>> to it means that the given core should be put offline.  Writing 1 means to put
>> it back online.  You can simply write first 0s and than 1s to those files
>> for CPUs > 0 multiple times in a row and see if that triggers messages like the
>> above.  If it does, that may mean there's been a change in kernel/cpu.c, for
>> example, that causes it to appear.  The change may have been made somewhere in
>> arch/x86 too, though.
>>
>>> >> If you have a testcase for me to reproduce it here, I would be happy.
>>> >
>>> > Do you mean the freezer-related issue?
>>> >
>>>
>>> Any one as I am still stepping in the dark.
>>> I checked my disc-space as I built a lot of software today and run
>>> once out of space.
>>> But 1.7GiB should be enough on / for testing.
>>> I wanted to run the new LTP version I built the last days.
>>> Let's see what I get...
>>
>> Stress-testing the freezer is rather easy and doesn't require disk space.
>> All it takes is to echo "freezer" to /sys/power/pm_test and then do
>> "echo mem > /sys/power/state && sleep 1" in a loop.  This is described in
>> Documentation/power/basic-pm-debugging.txt IIRC.
>>
>
> [ CCing TTY and FBDEV folks ]
>
> [ TESTCASE ]
>
> kernel-config: CONFIG_PM_DEBUG=y
>
> root# echo "freezer" > /sys/power/pm_test
>
> root# echo mem > /sys/power/state && sleep 1
>
> This produces several TTY call-traces...
>
> +[  810.417180] ------------[ cut here ]------------
> +[  810.417203] WARNING: at drivers/tty/tty_buffer.c:475
> flush_to_ldisc+0x12f/0x1f0()
> +[  810.417207] Hardware name: 530U3BI/530U4BI/530U4BH
> +[  810.417210] tty is NULL
> +[  791.200932] Freezing remaining freezable tasks ...
> +[  810.417213] Modules linked in: bnep rfcomm parport_pc ppdev
> snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm arc4
> iwldvm ghash_clmulni_intel aesni_intel snd_hda_intel mac80211 xts
> uvcvideo snd_hda_codec aes_x86_64 lrw snd_hwdep gf128mul
> videobuf2_vmalloc joydev ablk_helper snd_pcm i915 videobuf2_memops
> cryptd videobuf2_core snd_page_alloc videodev snd_seq_midi
> snd_seq_midi_event iwlwifi snd_rawmidi snd_seq i2c_algo_bit snd_timer
> drm_kms_helper psmouse snd_seq_device drm btusb microcode cfg80211 snd
> bluetooth serio_raw soundcore lpc_ich samsung_laptop wmi mei mac_hid
> video lp parport hid_generic r8169 usbhid hid
> +[  810.417307] Pid: 37, comm: kworker/0:1 Not tainted
> 3.8.0-rc4-next20130118-3-iniza-generic #1
> +[  810.417310] Call Trace:
> +[  810.417325]  [<ffffffff81058acf>] warn_slowpath_common+0x7f/0xc0
> +[  810.417332]  [<ffffffff81058bc6>] warn_slowpath_fmt+0x46/0x50
> +[  810.417340]  [<ffffffff8141b03f>] flush_to_ldisc+0x12f/0x1f0
> +[  810.417349]  [<ffffffff81077d95>] process_one_work+0x155/0x460
> +[  810.417357]  [<ffffffff81078a38>] worker_thread+0x168/0x410
> +[  810.417364]  [<ffffffff810788d0>] ? manage_workers+0x2c0/0x2c0
> +[  810.417371]  [<ffffffff8107ded0>] kthread+0xc0/0xd0
> +[  810.417377]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> +[  810.417385]  [<ffffffff816beaec>] ret_from_fork+0x7c/0xb0
> +[  810.417427]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> +[  810.417438] ---[ end trace a302c76f044b14c2 ]---
>
> ...and my first reported call-trace is also seen afterwards...
>
> +[  811.192835] Freezing of tasks failed after 20.01 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> +[  811.192957] jbd2/loop0-8    D ffffffff8180d780     0   289      2 0x00000000
> +[  811.192966]  ffff880118115b68 0000000000000046 ffff880118761720
> 0000000000000001
> +[  811.192974]  ffff880118761720 ffff880118115fd8 ffff880118115fd8
> ffff880118115fd8
> +[  811.192981]  ffffffff81c15440 ffff880118761720 ffff880118115b68
> ffff88011fa14738
> +[  811.192988] Call Trace:
> +[  811.193006]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
> +[  811.193015]  [<ffffffff816b5149>] schedule+0x29/0x70
> +[  811.193021]  [<ffffffff816b521f>] io_schedule+0x8f/0xd0
> +[  811.193028]  [<ffffffff811c683e>] sleep_on_buffer+0xe/0x20
> +[  811.193037]  [<ffffffff816b3a1f>] __wait_on_bit+0x5f/0x90
> +[  811.193044]  [<ffffffff811c5ef1>] ? submit_bh+0x121/0x1e0
> +[  811.193051]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
> +[  811.193058]  [<ffffffff816b3acc>] out_of_line_wait_on_bit+0x7c/0x90
> +[  811.193067]  [<ffffffff8107eb00>] ? autoremove_wake_function+0x40/0x40
> +[  811.193073]  [<ffffffff811c682e>] __wait_on_buffer+0x2e/0x30
> +[  811.193085]  [<ffffffff8128aaf1>]
> jbd2_journal_commit_transaction+0x1791/0x1960
> +[  811.193093]  [<ffffffff816b62de>] ? _raw_spin_lock_irqsave+0x2e/0x40
> +[  811.193102]  [<ffffffff81069fbf>] ? try_to_del_timer_sync+0x4f/0x70
> +[  811.193109]  [<ffffffff8128e938>] kjournald2+0xb8/0x240
> +[  811.193115]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
> +[  811.193120]  [<ffffffff8128e880>] ? commit_timeout+0x10/0x10
> +[  811.193126]  [<ffffffff8107ded0>] kthread+0xc0/0xd0
> +[  811.193132]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> +[  811.193139]  [<ffffffff816beaec>] ret_from_fork+0x7c/0xb0
> +[  811.193144]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> +[  811.193228]
> +[  811.193231] Restarting kernel threads ... done.
> +[  811.193403] Restarting tasks ... done.
>
> Thanks Rafael for the hints and your patience!
>
> Hope TTY/FBDEV folks can help.
>
> IMPORTANT NOTE:
> I have tested with some patches on top of Linux-Next (next-20130118),
> see attached patches file!
>

This looks like a typo to me...

--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -471,7 +471,7 @@ static void flush_to_ldisc(struct work_struct *work)
        unsigned long   flags;
        struct tty_ldisc *disc;

-       tty = port->itty;
+       tty = port->tty;
        if (WARN_RATELIMIT(tty == NULL, "tty is NULL\n"))
                return;

- Sedat -

> - Sedat -
>
>> Thanks,
>> Rafael
>>
>>
>> --
>> I speak only for myself.
>> Rafael J. Wysocki, Intel Open Source Technology Center.
