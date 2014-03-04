Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbaCDNpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:45:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52479 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbaCDNpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:45:13 -0500
Date: Tue, 4 Mar 2014 14:45:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
Message-ID: <20140304134509.GA5427@pd.tnic>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz>
 <alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:20:11PM +0100, Jiri Kosina wrote:
> I encountered this again with -rc5.
> 
> If there is anything I can do to help debug this, please let me know.

I have a similar issue where the screen blanks after the machine idle
timeout expires (not suspending the box - just leaving it idle) and then
when I press any button to wake up the screen, it remains off. The box
is otherwise alive, I can log into it and restart X. Then the screen is
back on. This started appearing in the -rc3-4 timeframe AFAICT.

My GPU is

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Lenovo Device 21fa
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 4000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>
        Kernel driver in use: i915
00: 86 80 66 01 07 04 90 00 09 00 00 03 00 00 00 00
10: 04 00 00 f0 00 00 00 00 0c 00 00 e0 00 00 00 00
20: 01 40 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00

Maybe I should say that I'm booting the box with

[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.14.0-rc5+ root=/dev/sdb2 ro root=/dev/sdb2 ignore_loglevel log_buf_len=10M resume=/dev/sdb1 i915.i915_enable_rc6=4 i915.i915_enable_fbc=1 i915.lvds_downclock=1 i915.powersave=1

with a bunch of those powersaving switches on which has been the case
since I have this box. Maybe their functionality changed?

Here's what dmesg has to say about i915:

[    0.627069] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.737736] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    1.571745] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.571792] i915 0000:00:02.0: registered panic notifier
[    1.586252] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
