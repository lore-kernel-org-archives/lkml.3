Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3CSArH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:47:07 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:56005 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab3CSArE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
Date: Mon, 18 Mar 2013 18:47:02 -0600
Message-ID: <CAKocOOOWMRDKLJmT5MCbGdV4H+dWsYZY89CvG6OzPKaZkCe74Q@mail.gmail.com>
Subject: Re: [ 00/40] 3.0.70-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, eranian@google.com,
        parag.lkml@gmail.com, torvalds@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:10 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.0.70 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar 20 21:10:06 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.70-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

I am seeing the following warning right after resume:

[  338.872618] ------------[ cut here ]------------
[  338.872623] WARNING: at kernel/power/suspend_test.c:53
suspend_test_finish+0x86/0x90()
[  338.872625] Hardware name: HP EliteBook 6930p
[  338.872626] Component: resume devices, time: 10068
[  338.872627] Modules linked in: ip6table_filter ip6_tables
ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc bluetooth radeon
snd_hda_codec_analog snd_hda_intel snd_hda_codec ttm snd_hwdep snd_pcm
snd_seq_midi snd_rawmidi binfmt_misc drm_kms_helper snd_seq_midi_event
drm snd_seq snd_timer snd_seq_device snd pata_pcmcia joydev
tpm_infineon dm_multipath soundcore psmouse snd_page_alloc pcmcia
hp_accel ppdev serio_raw i2c_algo_bit lis3lv02d hp_wmi sparse_keymap
parport_pc yenta_socket pcmcia_rsrc pcmcia_core input_polldev video
mac_hid wmi tpm_tis lp parport firewire_ohci firewire_core sdhci_pci
crc_itu_t sdhci e1000e [last unloaded: kvm]
[  338.872662] Pid: 2656, comm: bash Not tainted 3.0.70-rc1+ #15
[  338.872664] Call Trace:
[  338.872667]  [<ffffffff8105ef1f>] warn_slowpath_common+0x7f/0xc0
[  338.872670]  [<ffffffff8105f016>] warn_slowpath_fmt+0x46/0x50
[  338.872672]  [<ffffffff810a1b16>] suspend_test_finish+0x86/0x90
[  338.872675]  [<ffffffff810a16f4>] suspend_devices_and_enter+0xd4/0x2e0
[  338.872677]  [<ffffffff810a1a1d>] enter_state+0x11d/0x150
[  338.872679]  [<ffffffff810a0e67>] state_store+0xb7/0xf0
[  338.872682]  [<ffffffff812d531f>] kobj_attr_store+0xf/0x30
[  338.872685]  [<ffffffff811ce64f>] sysfs_write_file+0xef/0x170
[  338.872688]  [<ffffffff8115e2a3>] vfs_write+0xb3/0x180
[  338.872691]  [<ffffffff8115e5ca>] sys_write+0x4a/0x90
[  338.872694]  [<ffffffff81604b42>] system_call_fastpath+0x16/0x1b
[  338.872696] ---[ end trace 9c87f459a9254076 ]---
[  338.872805] PM: Finishing wakeup.
[  338.872806] Restarting tasks ... done.
[  338.886692] video LNXVIDEO:00: Restoring backlight state

-- Shuah
