Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaESHIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:08:23 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40053 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaESHIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:08:21 -0400
Message-ID: <5379AE46.3000407@gmail.com>
Date: Mon, 19 May 2014 09:09:58 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: kernel 3.14.2 oops: seems related to EFI
References: <53777F7B.8060407@gmail.com> <20140518134206.GA8040@pd.tnic>
In-Reply-To: <20140518134206.GA8040@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2014 03:42 PM, Borislav Petkov wrote:
> On Sat, May 17, 2014 at 05:25:47PM +0200, Francis Moreau wrote:
>> [  +0.018677] general protection fault: 0000 [#1] PREEMPT SMP
>> [  +0.000068] Modules linked in: usb_storage tun raid1 md_mod loop fuse
>> joydev coretemp hwmon arc4 intel_rapl x86_pkg_temp_thermal
>> intel_powerclamp kvm_intel nls_iso8859_1 nls_cp437 iTCO_wdt kvm vfat fat
>> iTCO_vendor_support iwldvm uvcvideo led_class crct10dif_pclmul
>> crc32_pclmul crc32c_intel ghash_clmulni_intel mac80211 videobuf2_vmalloc
>> videobuf2_memops videobuf2_core aesni_intel videodev aes_x86_64
>> snd_hda_codec_hdmi lrw gf128mul mousedev glue_helper btusb
>> snd_hda_codec_via ablk_helper media cryptd iwlwifi snd_hda_codec_generic
>> bluetooth psmouse microcode i2c_i801 serio_raw cfg80211 6lowpan_iphc
>> rtsx_pci_ms r8169 memstick rfkill lpc_ich mii snd_hda_intel
>> snd_hda_codec thermal snd_hwdep wmi snd_pcm tpm_infineon snd_timer
>> tpm_tis mei_me snd tpm mei shpchp evdev soundcore processor battery
>> mac_hid ac
>> [  +0.000803]  ext4 crc16 mbcache jbd2 hid_generic usbhid hid bcache
>> sd_mod sr_mod crc_t10dif cdrom crct10dif_common rtsx_pci_sdmmc mmc_core
>> atkbd libps2 ahci libahci ehci_pci libata xhci_hcd ehci_hcd scsi_mod
>> rtsx_pci usbcore usb_common i8042 serio i915 video button intel_gtt
>> i2c_algo_bit drm_kms_helper drm i2c_core
>> [  +0.000328] CPU: 0 PID: 30835 Comm: systemd-udevd Not tainted
>> 3.14.2-1-ARCH #1
>> [  +0.000064] Hardware name: CLEVO CO.                        W55xEU
>>                       /W55xEU                          , BIOS 4.6.5
>> 03/05/2013
>> [  +0.000102] task: ffff880405ee6bf0 ti: ffff880400f4a000 task.ti:
>> ffff880400f4a000
>> [  +0.000060] RIP: 0010:[<ffffffff810655af>]  [<ffffffff810655af>]
>> efi_call5+0x6f/0xf0
>> [  +0.000071] RSP: 0018:ffff880400f4bdb0  EFLAGS: 00010002
>> [  +0.000045] RAX: 0000000080050033 RBX: ffff8804040e3000 RCX:
>> ffff8804040e3000
>> [  +0.000055] RDX: ffff8804040e3400 RSI: ffff8804040e3000 RDI:
>> bff7fffff7afffff
> 
> So you get a #GP while executing call *rdi and %rdi is supposed to
> contain ->get_variable. But instead it contains some very funky shit:
> 
> 0xbff7fffff7afffff
> 
> Who made it contain that nuisance of a pointer which thinks it is
> ->get_variable, huh? If only I could get my hands on that guy! :-P
> 
> Ok, seriously, how reproducible is this?

I don't really know how to reproduce this, I only can say that it
usually happens while partitioning the loop device or perhaps when the
kernel reads the partition table afterwards.

> Can you reproduce with the
> latest upstream kernel too, i.e. 3.15-rc5+?

I don't know, I can't really afford to configure/compile/test this new
kernel, sorry.

Thanks
