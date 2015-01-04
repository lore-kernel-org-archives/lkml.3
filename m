Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbbADHxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 02:53:15 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:39370 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADHxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 02:53:14 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CACVXFVPvi1mjJKKX8UuFA02Ci376C-pMdyY9=1xWG9G10QdGfA@mail.gmail.com>
References: <CA+icZUWDMUBLq5=ydDtWnPadz0CBTQRHCeZnDVOvTjL4kYjfWA@mail.gmail.com>
	<CA+icZUVMEqD9uDouL=FM8147NoWsgufkn2odTKEDgtiqcN3_3Q@mail.gmail.com>
	<CACVXFVPvi1mjJKKX8UuFA02Ci376C-pMdyY9=1xWG9G10QdGfA@mail.gmail.com>
Date: Sun, 4 Jan 2015 08:53:12 +0100
Message-ID: <CA+icZUWO=062JpKOKwwJR3LjKf9X-VjAkJL7nmqYy_iWo0X7qg@mail.gmail.com>
Subject: Re: [next-20141231] sched: WARNING: CPU: 1 PID: 2539 at
 kernel/sched/core.c:7303 __might_sleep+0xbd/0xd0()
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, Jens Axboe <axboe@fb.com>,
        "open list:AIO" <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 1:59 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi Sedat,
>
> On Sun, Jan 4, 2015 at 7:42 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Jan 1, 2015 at 11:28 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> Hi,
>>>
>>> with next-20141231 I am seeing this call-trace:
>>>
>>> [   88.028632] ------------[ cut here ]------------
>>> [   88.028643] WARNING: CPU: 1 PID: 2539 at kernel/sched/core.c:7303
>>> __might_sleep+0xbd/0xd0()
>>> [   88.028646] do not call blocking ops when !TASK_RUNNING; state=1
>>> set at [<ffffffff810b82dd>] prepare_to_wait_event+0x5d/0x110
>>> [   88.028648] Modules linked in: ppp_deflate bsd_comp ppp_async
>>> crc_ccitt arc4 iwldvm uvcvideo mac80211 snd_hda_codec_hdmi
>>> snd_hda_codec_realtek parport_pc videobuf2_vmalloc
>>> snd_hda_codec_generic ppdev videobuf2_memops snd_hda_intel
>>> videobuf2_core rfcomm bnep snd_hda_controller option snd_hda_codec
>>> v4l2_common i915 joydev videodev usb_wwan snd_hwdep usbserial
>>> cdc_ether snd_pcm usbnet btusb snd_seq_midi snd_seq_midi_event
>>> bluetooth psmouse snd_rawmidi iwlwifi snd_seq i2c_algo_bit
>>> drm_kms_helper snd_timer serio_raw snd_seq_device samsung_laptop drm
>>> snd cfg80211 soundcore video lpc_ich intel_rst wmi mac_hid binfmt_misc
>>> lp parport hid_generic usbhid hid r8169 mii usb_storage
>>> [   88.028694] CPU: 1 PID: 2539 Comm: fio Not tainted
>>> 3.19.0-rc2-next20141231-1-iniza-small #1
>>> [   88.028695] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
>>> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
>>> [   88.028697]  ffffffff81a66d5f ffff880070f43c38 ffffffff8175c50c
>>> 0000000000000000
>>> [   88.028700]  ffff880070f43c88 ffff880070f43c78 ffffffff810753ba
>>> ffff880070f43d28
>>> [   88.028703]  ffffffff81a67ef5 000000000000026d 0000000000000000
>>> 0000000000dce810
>>> [   88.028706] Call Trace:
>>> [   88.028712]  [<ffffffff8175c50c>] dump_stack+0x4c/0x65
>>> [   88.028716]  [<ffffffff810753ba>] warn_slowpath_common+0x8a/0xc0
>>> [   88.028719]  [<ffffffff81075436>] warn_slowpath_fmt+0x46/0x50
>>> [   88.028722]  [<ffffffff810c2c3d>] ? mark_held_locks+0x6d/0xa0
>>> [   88.028725]  [<ffffffff81761732>] ? mutex_lock_nested+0x2b2/0x4e0
>>> [   88.028727]  [<ffffffff810b82dd>] ? prepare_to_wait_event+0x5d/0x110
>>> [   88.028729]  [<ffffffff810b82dd>] ? prepare_to_wait_event+0x5d/0x110
>>> [   88.028731]  [<ffffffff8109c3ad>] __might_sleep+0xbd/0xd0
>>> [   88.028734]  [<ffffffff817614af>] mutex_lock_nested+0x2f/0x4e0
>>> [   88.028736]  [<ffffffff810b82d3>] ? prepare_to_wait_event+0x53/0x110
>>> [   88.028739]  [<ffffffff8124433f>] aio_read_events+0x4f/0x2d0
>>> [   88.028742]  [<ffffffff810c2e7d>] ? trace_hardirqs_on+0xd/0x10
>>> [   88.028745]  [<ffffffff812447c0>] read_events+0x200/0x320
>>> [   88.028747]  [<ffffffff810b81c0>] ? wait_woken+0xc0/0xc0
>>> [   88.028750]  [<ffffffff810e9690>] ? hrtimer_get_res+0x50/0x50
>>> [   88.028753]  [<ffffffff81244ca0>] ? lookup_ioctx+0xd0/0x140
>>> [   88.028755]  [<ffffffff812466b2>] SyS_io_getevents+0x62/0x100
>>> [   88.028759]  [<ffffffff813b59be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [   88.028762]  [<ffffffff817663ed>] system_call_fastpath+0x16/0x1b
>>> [   88.028764] ---[ end trace dba4f4a06fcdd178 ]---
>
> It is an known linux-aio issue, see the following link:
>
> http://marc.info/?t=141925049600004&r=1&w=2
>

This discussion resulted in a RFC patch of Chris Mason which is still
discussed in [1].

- Sedat -

[1] http://marc.info/?t=141929396100001&r=1&w=2
