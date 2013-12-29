Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3L2Bp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 20:45:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39776 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3L2Bpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 20:45:55 -0500
Date: Sun, 29 Dec 2013 02:44:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: amd microcode broken by 3.12.0?
Message-ID: <20131229014428.GA6041@nazgul.tnic>
References: <201312281137.12524.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201312281137.12524.gheskett@wdtv.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 11:37:12AM -0500, Gene Heskett wrote:
> Greetings;
> 
> Fresh build/boot of a PAE 3.12.0 on an AMD Phenom...
> 
> On checking dmesg, I see:
> 
> microcode: CPU0: patch_level=0x01000065
> microcode: CPU1: patch_level=0x01000065
> microcode: CPU2: patch_level=0x01000065
> microcode: CPU3: patch_level=0x01000065
> microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, 
> Peter Oruba
> 
> Fairly late since I don't have early microcode checked in the .config.

I have a bunch of fixes for that:

http://marc.info/?l=linux-kernel&m=138628638215162

wanna give them a try?

> FWIW, it didn't work when I had it checked either.
> 
> While booted to much older kernels, it reports that each cpu has been 
> brought up to patch level 0x01000083
> 
> So, stepping into /etc/init.d and doing a "sudo ./microcode_ctl", this is 
> returned:
> 
>  ./microcode_ctl: 90: gprintf: not found
> 
> Which has me scratching my head, wondering if my .config is screwed?

I don't think we ever did microcode update with the microcode_ctl on
AMD, did we? Hmmm.

In any case

echo 1 > /sys/devices/system/cpu/microcode/reload

should work.

HTH.
