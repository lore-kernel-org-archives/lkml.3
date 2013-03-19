Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3CSAu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:50:28 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:53695 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3CSAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
Date: Mon, 18 Mar 2013 18:50:25 -0600
Message-ID: <CAKocOOPeyVnL_x_fK6b52-S+bHFsw_D_83oQtEVoMOyPh0QD_g@mail.gmail.com>
Subject: Re: [ 00/48] 3.4.37-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, parag.lkml@gmail.com,
        eranian@google.com, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:08 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.4.37 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar 20 21:07:59 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.37-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

I am seeing the following warning after suspend and resume:

[  665.841331] Component: resume devices, time: 10628
[  665.841335] Modules linked in: ip6table_filter ip6_tables
ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc kvm_intel kvm bnep
rfcomm bluetooth arc4 iwlwifi radeon snd_hda_codec_analog
snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_pcm snd_seq_midi
binfmt_misc snd_rawmidi snd_seq_midi_event snd_seq ttm pata_pcmcia
snd_timer cfg80211 drm_kms_helper drm snd_seq_device tpm_infineon
pcmcia psmouse snd coretemp hp_wmi soundcore joydev sparse_keymap
snd_page_alloc yenta_socket hp_accel pcmcia_rsrc dm_multipath video
microcode serio_raw mac_hid lis3lv02d input_polldev ppdev tpm_tis
i2c_algo_bit pcmcia_core wmi parport_pc lp parport firewire_ohci
firewire_core crc_itu_t sdhci_pci sdhci e1000e
[  665.841446] Pid: 2686, comm: bash Not tainted 3.4.37-rc1+ #13
[  665.841450] Call Trace:
[  665.841463]  [<ffffffff8105136f>] warn_slowpath_common+0x7f/0xc0
[  665.841471]  [<ffffffff81051466>] warn_slowpath_fmt+0x46/0x50
[  665.841478]  [<ffffffff81097086>] suspend_test_finish+0x86/0x90
[  665.841484]  [<ffffffff81096c2e>] suspend_devices_and_enter+0x16e/0x330
[  665.841491]  [<ffffffff81096f7f>] pm_suspend+0x18f/0x1f0
[  665.841500]  [<ffffffff81095f97>] state_store+0xb7/0xf0
[  665.841508]  [<ffffffff81309a7f>] kobj_attr_store+0xf/0x30
[  665.841518]  [<ffffffff811e230f>] sysfs_write_file+0xef/0x170
[  665.841528]  [<ffffffff81173b43>] vfs_write+0xb3/0x180
[  665.841534]  [<ffffffff81173e6a>] sys_write+0x4a/0x90
[  665.841543]  [<ffffffff81664329>] system_call_fastpath+0x16/0x1b
[  665.841548] ---[ end trace bf9a1fe573180bcc ]---
[  665.841843] PM: Finishing wakeup.
[  665.841848] Restarting tasks ... done.

Same thing on 3.8.4-rc1.

-- Shuah
