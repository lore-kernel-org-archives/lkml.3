Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3DVN4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:56:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40009 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab3DVN4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:56:31 -0400
Date: Mon, 22 Apr 2013 15:56:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: paulmck@linux.vnet.ibm.com, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq 16: nobody cared
Message-ID: <20130422135629.GB4412@pd.tnic>
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <s5hfvyj55ke.wl%tiwai@suse.de>
 <20130422091310.GA4637@pd.tnic>
 <s5hzjwq53ec.wl%tiwai@suse.de>
 <20130422100657.GF4637@pd.tnic>
 <s5hobd64x6v.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hobd64x6v.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 01:33:12PM +0200, Takashi Iwai wrote:
> At Mon, 22 Apr 2013 12:06:57 +0200,
> Borislav Petkov wrote:
> > 
> > On Mon, Apr 22, 2013 at 11:19:07AM +0200, Takashi Iwai wrote:
> > > Is the PCI device a HD-audio controller for the built-in analog or
> > > a HDMI audio controller coupled with a graphics chip?
> > 
> > Hmm:
> > 
> > [    7.204020] snd_hda_intel 0000:01:00.1: irq 90 for MSI/MSI-X
> > [    7.551912]   #0: HDA ATI SB at 0xfeb00000 irq 16
> 
> So, you have two PCI HD-audio controllers, and 0000:01:00.1 is for
> HDMI while irq 16 is from another onboard audio.  Does the onboard
> audio PCI entry have no MSI support, right?

Looks like it:

$ grep snd /proc/interrupts
  16:        108        109        107        106        106        108        107        118   IO-APIC-fasteoi   snd_hda_intel
  90:          3          3          4          4          4          4          3          3   PCI-MSI-edge      snd_hda_intel

Btw in alsamixer, I have a bunch of controls for the SB soundcard and
when I select the HDMI sound card, it shows only one "S/PDIF" volume
control which can only be muted.

I'd guess this is the audio output over the monitor when it is connected
over HDMI or so.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
