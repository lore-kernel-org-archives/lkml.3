Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3ANOzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:55:48 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:62393 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab3ANOzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:55:46 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130114143238.GC20384@kroah.com>
References: <1357831934-31610-1-git-send-email-tomas.winkler@intel.com>
	<CA+icZUXa-cgNPTYAKjXDSkoqNhto7jz89yUMJAvYxa-jGtMbjg@mail.gmail.com>
	<20130114143238.GC20384@kroah.com>
Date: Mon, 14 Jan 2013 15:55:44 +0100
Message-ID: <CA+icZUXLFp_oZnVPcVDwuy_dvbywKgqHKknzg6qyF3o=mw-p+A@mail.gmail.com>
Subject: Re: [char-misc-next V2] mei: drop the warning when cl is not
 initialized during unlinking
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 3:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jan 14, 2013 at 03:14:50PM +0100, Sedat Dilek wrote:
>> On Thu, Jan 10, 2013 at 4:32 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
>> > On systems where wd and amthif is not initialized
>> > we will hit cl->dev == NULL. This condition is okay
>> > so we don't need to be laud about it.
>> >
>> > Fixes the follwing warning during suspend
>> > [  137.061985] WARNING: at drivers/misc/mei/client.c:315 mei_cl_unlink+0x86/0x90 [mei]()
>> > [  137.061986] Hardware name: 530U3BI/530U4BI/530U4BH
>> > [  137.062140] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek joydev coretemp kvm_intel snd_hda_intel snd_hda_codec kvm arc4 iwldvm snd_hwdep i915 snd_pcm mac80211 ghash_clmulni_intel snd_page_alloc aesni_intel snd_seq_midi xts snd_seq_midi_event aes_x86_64 rfcomm snd_rawmidi parport_pc bnep lrw snd_seq uvcvideo i2c_algo_bit ppdev gf128mul iwlwifi snd_timer drm_kms_helper ablk_helper cryptd drm snd_seq_device videobuf2_vmalloc psmouse videobuf2_memops snd cfg80211 btusb videobuf2_core soundcore videodev lp bluetooth samsung_laptop wmi microcode mei serio_raw mac_hid video hid_generic lpc_ich parport usbhid hid r8169
>> > [  137.062143] Pid: 2706, comm: kworker/u:15 Tainted: G      D W    3.8.0-rc2-next20130109-1-iniza-generic #1
>> > [  137.062144] Call Trace:
>> > [  137.062156]  [<ffffffff8105860f>] warn_slowpath_common+0x7f/0xc0
>> > [  137.062159]  [<ffffffff8135b1ea>] ? ioread32+0x3a/0x40
>> > [  137.062162]  [<ffffffff8105866a>] warn_slowpath_null+0x1a/0x20
>> > [  137.062168]  [<ffffffffa0076be6>] mei_cl_unlink+0x86/0x90 [mei]
>> > [  137.062173]  [<ffffffffa0071325>] mei_reset+0xc5/0x240 [mei]
>> > [  137.062178]  [<ffffffffa0073703>] mei_pci_resume+0xa3/0x110 [mei]
>> > [  137.062183]  [<ffffffff81379cae>] pci_pm_resume+0x7e/0xe0
>> > [  137.062185]  [<ffffffff81379c30>] ? pci_pm_thaw+0x80/0x80
>> > [  137.062189]  [<ffffffff8145a415>] dpm_run_callback.isra.6+0x25/0x50
>> > [  137.062192]  [<ffffffff8145a6cf>] device_resume+0x9f/0x140
>> > [  137.062194]  [<ffffffff8145a791>] async_resume+0x21/0x50
>> > [  137.062200]  [<ffffffff810858b0>] async_run_entry_fn+0x90/0x1c0
>> > [  137.062203]  [<ffffffff810778e5>] process_one_work+0x155/0x460
>> > [  137.062207]  [<ffffffff81078578>] worker_thread+0x168/0x400
>> > [  137.062210]  [<ffffffff81078410>] ? manage_workers+0x2b0/0x2b0
>> > [  137.062214]  [<ffffffff8107d9f0>] kthread+0xc0/0xd0
>> > [  137.062218]  [<ffffffff8107d930>] ? flush_kthread_worker+0xb0/0xb0
>> > [  137.062222]  [<ffffffff816bac6c>] ret_from_fork+0x7c/0xb0
>> > [  137.062228]  [<ffffffff8107d930>] ? flush_kthread_worker+0xb0/0xb0
>> >
>> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
>> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>>
>> Can you please apply this patch to char-misc-next?
>> I am hitting it again while doing other regression testing!
>
> Please be patient, it will get there soon.
>

The same answer I got for the report/testing of [1], it is still not
in mainline.
Yes, I have seen your pull-request for char-misc-linus of today, but
why does this takes weeks to apply?

*** Why don't you treat (reported and tested) regressions with a
higher priority? ***
This has nothing to do with patience! You steal other people's time!
Hitting other regressions while doing bisecting is really no fun.
( ...and [GIT-PULL] requests are cheap... or do you really think we
will wait until you emptied your inbox? )

It makes me angry to fell over and over the same sh*t.

The consequence is...

        CONFIG_INTEL_MEI=n

Test your code by yourself!

In your endless time you will find a minute to apply [2] as well (sarcasm off).

23-Dec-2012 [3]...

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/gregkh/char-misc.git;a=commitdiff;h=e6028db0146cf5a68dbd1508225ea49840997880
[2] https://patchwork.kernel.org/patch/1952421/
[3] http://lkml.org/lkml/2012/12/23/49

> greg k-h
