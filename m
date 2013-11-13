Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3KMVTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:19:45 -0500
Received: from nebula.mojo.cc ([46.4.89.19]:57541 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab3KMVTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:19:38 -0500
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Date: Wed, 13 Nov 2013 22:19:18 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at> <20131113200914.GG7251@phenom.ffwll.local> <20131113203319.GB23962@pd.tnic>
In-Reply-To: <20131113203319.GB23962@pd.tnic>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201311132219.18690.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 13 November 2013 21:33:19 Borislav Petkov wrote:
> Some more suggestions, in addition to Daniel's:
>
> On Wed, Nov 13, 2013 at 09:09:14PM +0100, Daniel Vetter wrote:
> > > Nov 13 09:36:21 maistor kernel: [   40.447271] ------------[ cut
> > > here ]------------
> > > Nov 13 09:36:21 maistor kernel: [   40.447311] WARNING: CPU: 1 PID:
> > > 4142 at drivers/gpu/drm/i915/intel_display.c:8292
> > > check_crtc_state+0x5cf/0xa60 [i915] ()
> > > Nov 13 09:36:21 maistor kernel: [   40.447313] pipe state doesn't
> > > match!
>
> That's
>
> 	if (active &&
> 	    !intel_pipe_config_compare(dev, &crtc->config, &pipe_config)) {
> 		WARN(1, "pipe state doesn't match!\n");				<---
> 		intel_dump_pipe_config(crtc, &pipe_config,
> 				       "[hw state]");
> 		intel_dump_pipe_config(crtc, &crtc->config,
> 				       "[sw state]");
> 	}
>

I looked there, but it would have taken more time then available to get an 
idea on what it is exactly trying to do

> > > Nov 13 09:36:21 maistor kernel: [   40.447315] Modules linked in:
> > > snd_hrtimer acpi_pad sbs sbshc fan binfmt_misc uinput fuse af_packet
> > > ipv6 firewire_sbp2 snd
> > > _hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
> > > snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy snd_seq_oss
> > > snd_seq_midi
> > > snd_seq_midi_eve
> > > nt snd_rawmidi snd_seq snd_seq_device snd_timer arc4 iTCO_wdt snd
> > > gpio_ich iwl3945 dell_wmi sparse_keymap i2c_i801 iTCO_vendor_support
> > > ehci_pci iwlegacy mac8
> > > 0211 cfg80211 soundcore rfkill dell_laptop lpc_ich yenta_socket
> > > pcmcia_rsrc irda 8250 evdev wmi processor dcdbas rtc_cmos battery
> > > crc_ccitt ac joydev sha256_
> > > ssse3 sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod sg
> > > b44 sr_mod cdrom ssb i915 cfbfillrect cfbimgblt mmc_core mii pcmcia
> > > pcmcia_core uhci_
> > > hcd i2c_algo_bit cfbcopyarea firewire_ohci video backlight
> > > firewire_core crc_itu_t drm_kms_helper drm ehci_hcd sd_mod i2c_core
> > > thermal thermal_sys freq_table
> > >  usbcore usb_common button intel_agp intel_gtt agpgart
> > > Nov 13 09:36:21 maistor kernel: [   40.447384] CPU: 1 PID: 4142 Comm:
> > > Xorg Tainted: P             3.11.6eko2 #3
>
> And there's that taint P again due to the vmware modules.
>
> I know that you tried without the vmware modules where your kernel
> wasn't tainted but then you got a #GP which could be something entirely
> different. But now you're hitting some sanity-checking code which could
> mean there's some corruption happening.

Yes with #GP machine locks and this time it didn't 

>
> So, can you reproduce that exact same warning, i.e. this one:
>
> WARNING: CPU: 1 PID: 4142 at drivers/gpu/drm/i915/intel_display.c:8292
> check_crtc_state+0x5cf/0xa60 [i915]() pipe state doesn't match!
>
> *without* the vmware modules installed?

I'm not sure - you know it happens random

>
> Also, it wouldn't hurt to try the shiny new 3.12.

I was thinking to do so - but lets be honest. I would save everybody's time if 
I were 100% sure it is a hardware issue and I would buy a new notebook. The 
one was serving great for the past 7y and it payed off itself already long 
time ago.
I could try 3.12 and also try in combination with the git drm-intel as Daniel 
suggested.
I'm still thinking that his has something to do with the graphics, but rather 
guessing from intuition.

I'm not sure if it helps somehow but when I grep as following I find only the 
tainted erros - it's not visible which of them were GP, but still it shows 
where it hit the issue

zgrep 'Comm:' messages* | more
messages:Nov 11 10:52:42 maistor kernel: [   43.961984] CPU: 1 PID: 4103 Comm: 
Xorg Tainted: P             3.11.6eko2 #3
messages:Nov 11 10:52:54 maistor kernel: [   55.759687] CPU: 1 PID: 4103 Comm: 
Xorg Tainted: P        W    3.11.6eko2 #3
messages:Nov 12 10:35:42 maistor kernel: [   28.626271] CPU: 0 PID: 3895 Comm: 
Xorg Tainted: P             3.11.6eko2 #3
messages:Nov 12 10:35:55 maistor kernel: [   41.618447] CPU: 1 PID: 3895 Comm: 
Xorg Tainted: P        W    3.11.6eko2 #3
messages:Nov 13 09:36:21 maistor kernel: [   40.447384] CPU: 1 PID: 4142 Comm: 
Xorg Tainted: P             3.11.6eko2 #3
messages:Nov 13 09:36:34 maistor kernel: [   53.624754] CPU: 0 PID: 4142 Comm: 
Xorg Tainted: P        W    3.11.6eko2 #3
messages.1:Nov  4 11:21:19 maistor kernel: [   38.497643] CPU: 1 PID: 4104 
Comm: Xorg Tainted: P             3.11.6eko2 #3
messages.1:Nov  4 11:21:31 maistor kernel: [   50.844193] CPU: 0 PID: 4104 
Comm: Xorg Tainted: P        W    3.11.6eko2 #3
messages.1:Nov  5 10:28:49 maistor kernel: [   39.545474] CPU: 1 PID: 4253 
Comm: Xorg Tainted: P             3.11.6eko2 #3
messages.1:Nov  5 10:29:02 maistor kernel: [   52.078761] CPU: 0 PID: 4253 
Comm: Xorg Tainted: P        W    3.11.6eko2 #3
messages.1:Nov  6 10:33:01 maistor kernel: [   38.876587] CPU: 0 PID: 4128 
Comm: Xorg Tainted: P             3.11.6eko2 #3
messages.1:Nov  6 10:33:12 maistor kernel: [   49.777082] CPU: 0 PID: 4128 
Comm: Xorg Tainted: P        W    3.11.6eko2 #3
messages.1:Nov  7 10:27:40 maistor kernel: [   38.771546] CPU: 0 PID: 4110 
Comm: Xorg Tainted: P             3.11.6eko2 #3
messages.1:Nov  7 10:27:53 maistor kernel: [   51.896606] CPU: 1 PID: 4110 
Comm: Xorg Tainted: P        W    3.11.6eko2 #3
messages.1:Nov  8 10:35:13 maistor kernel: [   42.021333] CPU: 1 PID: 4224 
Comm: Xorg Tainted: P             3.11.6eko2 #3
messages.1:Nov  8 10:35:22 maistor kernel: [   51.699993] CPU: 0 PID: 4224 
Comm: Xorg Tainted: P        W    3.11.6eko2 #3
messages.2.gz:Oct 27 19:01:29 maistor kernel: CPU: 1 PID: 6111 Comm: 
plugin-containe Tainted: P           O 3.11.6eko2 #1
messages.2.gz:Oct 27 22:15:14 maistor kernel: CPU: 1 PID: 9024 Comm: 
plugin-containe Tainted: P           O 3.11.6eko2 #1
messages.2.gz:Oct 28 10:33:34 maistor kernel: CPU: 0 PID: 4195 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.2.gz:Oct 28 10:33:43 maistor kernel: CPU: 0 PID: 4195 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.2.gz:Oct 29 10:34:29 maistor kernel: CPU: 1 PID: 4633 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.2.gz:Oct 29 10:34:41 maistor kernel: CPU: 1 PID: 4633 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.2.gz:Oct 30 10:30:55 maistor kernel: CPU: 1 PID: 4030 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.2.gz:Oct 30 10:31:06 maistor kernel: CPU: 0 PID: 4030 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.2.gz:Oct 31 10:51:01 maistor kernel: CPU: 1 PID: 6441 Comm: Xorg 
Tainted: P           O 3.11.6eko2 #1
messages.2.gz:Oct 31 10:51:08 maistor kernel: CPU: 1 PID: 6441 Comm: Xorg 
Tainted: P        W  O 3.11.6eko2 #1
messages.2.gz:Nov  2 06:32:48 maistor kernel: CPU: 0 PID: 5925 Comm: Socket 
Thread Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 20 02:37:01 maistor kernel: CPU: 0 PID: 5952 Comm: Socket 
Thread Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 20 23:34:00 maistor kernel: CPU: 0 PID: 14534 Comm: 
plugin-containe Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 20 23:34:24 maistor kernel: CPU: 1 PID: 14535 Comm: 
plugin-containe Tainted: P      D      3.11.6eko2 #1
messages.3.gz:Oct 20 23:34:52 maistor kernel: CPU: 1 PID: 14535 Comm: 
plugin-containe Tainted: P      D      3.11.6eko2 #1
messages.3.gz:Oct 20 23:35:20 maistor kernel: CPU: 1 PID: 14535 Comm: 
plugin-containe Tainted: P      D      3.11.6eko2 #1
messages.3.gz:Oct 20 23:35:48 maistor kernel: CPU: 1 PID: 14535 Comm: 
plugin-containe Tainted: P      D      3.11.6eko2 #1
messages.3.gz:Oct 20 23:36:16 maistor kernel: CPU: 1 PID: 14535 Comm: 
plugin-containe Tainted: P      D      3.11.6eko2 #1
messages.3.gz:Oct 20 23:36:44 maistor kernel: CPU: 1 PID: 14535 Comm: 
plugin-containe Tainted: P      D      3.11.6eko2 #1
messages.3.gz:Oct 20 23:37:12 maistor kernel: CPU: 1 PID: 14535 Comm: 
plugin-containe Tainted: P      D      3.11.6eko2 #1
messages.3.gz:Oct 21 10:42:33 maistor kernel: CPU: 0 PID: 4002 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 21 10:42:45 maistor kernel: CPU: 1 PID: 4002 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.3.gz:Oct 22 11:24:20 maistor kernel: CPU: 1 PID: 4129 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 22 11:24:30 maistor kernel: CPU: 1 PID: 4129 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.3.gz:Oct 23 11:09:10 maistor kernel: CPU: 1 PID: 4197 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 23 11:09:18 maistor kernel: CPU: 1 PID: 4197 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.3.gz:Oct 24 11:00:12 maistor kernel: CPU: 0 PID: 3981 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 24 11:00:23 maistor kernel: CPU: 1 PID: 3981 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.3.gz:Oct 25 12:55:49 maistor kernel: CPU: 0 PID: 4564 Comm: Xorg 
Tainted: P             3.11.6eko2 #1
messages.3.gz:Oct 25 12:56:01 maistor kernel: CPU: 1 PID: 4564 Comm: Xorg 
Tainted: P        W    3.11.6eko2 #1
messages.3.gz:Oct 26 21:57:03 maistor kernel: CPU: 0 PID: 30118 Comm: 
plugin-containe Tainted: P           O 3.11.6eko2 #1
messages.3.gz:Oct 26 21:57:27 maistor kernel: CPU: 1 PID: 30117 Comm: 
plugin-containe Tainted: P      D    O 3.11.6eko2 #1
messages.3.gz:Oct 26 21:57:55 maistor kernel: CPU: 1 PID: 30117 Comm: 
plugin-containe Tainted: P      D    O 3.11.6eko2 #1
messages.3.gz:Oct 26 21:58:23 maistor kernel: CPU: 1 PID: 30117 Comm: 
plugin-containe Tainted: P      D    O 3.11.6eko2 #1
messages.3.gz:Oct 26 21:58:51 maistor kernel: CPU: 1 PID: 30117 Comm: 
plugin-containe Tainted: P      D    O 3.11.6eko2 #1
messages.3.gz:Oct 26 21:59:19 maistor kernel: CPU: 1 PID: 30117 Comm: 
plugin-containe Tainted: P      D    O 3.11.6eko2 #1
messages.4.gz:Oct 14 19:40:28 maistor kernel: CPU: 1 PID: 19163 Comm: konsole 
Tainted: P           O 3.10.9eko2 #4
messages.4.gz:Oct 14 19:42:04 maistor kernel: CPU: 0 PID: 26225 Comm: wfica 
Tainted: P      D    O 3.10.9eko2 #4
messages.4.gz:Oct 14 20:17:55 maistor kernel: CPU: 1 PID: 390 Comm: kswapd0 
Tainted: P      D    O 3.10.9eko2 #4
messages.4.gz:Oct 15 20:16:45 maistor kernel: CPU: 0 PID: 4058 Comm: Xorg 
Tainted: P           O 3.10.9eko2 #4
messages.4.gz:Oct 17 10:40:44 maistor kernel: CPU: 1 PID: 6417 Comm: 
plugin-containe Tainted: P           O 3.10.9eko2 #4
messages.4.gz:Oct 17 12:42:09 maistor kernel: CPU: 1 PID: 390 Comm: kswapd0 
Tainted: P      D    O 3.10.9eko2 #4
messages.4.gz:Oct 17 13:16:14 maistor kernel: CPU: 0 PID: 6108 Comm: kmix 
Tainted: P           O 3.10.9eko2 #4
messages.4.gz:Oct 17 13:17:33 maistor kernel: CPU: 1 PID: 20690 Comm: 
udisks-daemon Tainted: P      D    O 3.10.9eko2 #4
messages.4.gz:Oct 17 13:17:33 maistor kernel: CPU: 1 PID: 20690 Comm: 
udisks-daemon Tainted: P      D W  O 3.10.9eko2 #4
messages.4.gz:Oct 17 13:56:58 maistor kernel: CPU: 1 PID: 13731 Comm: 
plugin-containe Tainted: P           O 3.10.9eko2 #4
messages.4.gz:Oct 17 13:57:04 maistor kernel: CPU: 0 PID: 4494 Comm: Xorg 
Tainted: P        W  O 3.10.9eko2 #4
