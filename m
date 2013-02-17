Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3BQRBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 12:01:25 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:35642 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3BQRBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:01:23 -0500
Date: Sun, 17 Feb 2013 11:01:11 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 3.7 HDMI channel map regression
Message-ID: <20130217170111.GA21967@lintop>
References: <20130128011827.GA30485@lintop>
 <s5h1ud5bs8u.wl%tiwai@suse.de>
 <20130129025205.GB30485@lintop>
 <20130217002225.GA20562@lintop>
 <s5h621rcp8y.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h621rcp8y.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 09:34:53AM +0100, Takashi Iwai wrote:
> At Sat, 16 Feb 2013 18:22:25 -0600,
> Shawn Bohrer wrote:
> > 
> > On Mon, Jan 28, 2013 at 08:52:05PM -0600, Shawn Bohrer wrote:
> > > On Mon, Jan 28, 2013 at 09:56:33AM +0100, Takashi Iwai wrote:
> > > > At Sun, 27 Jan 2013 19:18:27 -0600,
> > > > Shawn Bohrer wrote:
> > > > > 
> > > > > Hi Takashi,
> > > > > 
> > > > > I recently updated my HTPC from 3.6.11 to 3.7.2 and this caused my RL
> > > > > and FC channels to swap, and my RR and LFE channels to swap for PCM
> > > > > audio.  Doing a git bisect identified
> > > > > d45e6889ee69456a4d5b1bbb32252f460cd48fa9 "ALSA: hda - Provide the
> > > > > proper channel mapping for generic HDMI driver" as the commit that
> > > > > caused my channels to swap.  The commit doesn't revert cleanly on
> > > > > 3.7.4, and I haven't really looked to see what the correct fix might
> > > > > be.
> > > > > 
> > > > > Some info that may be relevant, the sound card is a:
> > > > > 
> > > > > 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
> > > > > Family High Definition Audio Controller (rev 04)
> > > > > 
> > > > > The machine is running Fedora 18 and audio goes over HDMI to a 5.1
> > > > > receiver.  I'm not really sure what other info you might need, but
> > > > > let me know if you need something else or have any patches you would
> > > > > like me to test.
> > > > 
> > > > OK, it's the first time to get a bug report about this.
> > > > Could you tell me how did you test it (i.e. which application, which
> > > > sound backend)?  Can you confirm that it's reproduced via speaker-test
> > > > program in alsa-utils package?
> > > 
> > > I originally noticed the problem when all of the dialog started coming
> > > out of my rear left speaker in MythTV after the kernel update.  Then I
> > > started using the Gnome 3 sound configuration gui in the system
> > > settings which has a speaker test and I assume is using pulseaudio.
> > > Running 'speaker-test -c6 -l1 -twav' also reproduces the problem.
> > > 
> > > For reference here are the versions of the various packages that I'm
> > > running:
> > > 
> > > alsa-utils-1.0.26-1.fc18.x86_64
> > > alsa-firmware-1.0.25-2.fc18.noarch
> > > alsa-plugins-pulseaudio-1.0.26-2.fc18.x86_64
> > > alsa-lib-devel-1.0.26-2.fc18.x86_64
> > > alsa-lib-1.0.26-2.fc18.x86_64
> > > alsa-tools-firmware-1.0.26.1-1.fc18.x86_64
> > > pulseaudio-gdm-hooks-2.1-5.fc18.x86_64
> > > pulseaudio-libs-2.1-5.fc18.x86_64
> > > pulseaudio-libs-glib2-2.1-5.fc18.x86_64
> > > pulseaudio-module-x11-2.1-5.fc18.x86_64
> > > pulseaudio-module-bluetooth-2.1-5.fc18.x86_64
> > > pulseaudio-2.1-5.fc18.x86_64
> > > pulseaudio-utils-2.1-5.fc18.x86_64
> > 
> > Hi Takashi,
> > 
> > Any updates on this issue?  I'd really like to see this issue fixed
> > and am happy to help in any way I can.  Until this gets fixed I'm
> > stuck on a 3.6.* kernel.
> 
> There is one fix in sound git tree regarding the HDMI channel map, but
> it's queued for 3.9 kernel (then backported to stable tree).
> Try sound.git tree or wait for a while until the upstream merge
> process above is done.

Thanks Takashi, I just tested the sound.git master branch and this
does indeed fix my issue.  I'll look forward to this going into 3.9.

--
Shawn
