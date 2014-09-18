Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbaIRQ4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:56:50 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34220 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbaIRQ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:56:48 -0400
Date: Thu, 18 Sep 2014 09:56:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Clemens Ladisch <clemens@ladisch.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: joystick - Use ktime for measuring timing
Message-ID: <20140918165642.GA14809@core.coreip.homeip.net>
References: <s5h8ulrzcwy.wl-tiwai@suse.de>
 <20140917192337.GA27319@rhlx01.hs-esslingen.de>
 <s5hmw9x8km7.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmw9x8km7.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 09:15:44AM +0200, Takashi Iwai wrote:
> At Wed, 17 Sep 2014 21:23:37 +0200,
> Andreas Mohr wrote:
> > 
> > Hi,
> > 
> > On Wed, Sep 10, 2014 at 05:57:17PM +0200, Takashi Iwai wrote:
> > > The current codes in gameport and analog joystick drivers for the time
> > > accounting have a long-standing problem when the system is running
> > > with CPU freq; since the timing is measured via TSC or sample counter,
> > > the calculation isn't reliable.
> > 
> > Thank you very much for having followed through on this!
> > (somehow you never seem to disappoint me :)
> > 
> > While working on testing this and doing various gameport/soundcard modifications,
> > I'm afraid I have seen the following checkpatch.pl (of v3.16) warnings:
> > 
> > WARNING: Missing a blank line after declarations
> > #164: FILE: drivers/input/joystick/analog.c:192:
> > +               unsigned int x;
> > +               GET_TIME(x);
> > 
> > WARNING: line over 80 characters
> > #224: FILE: drivers/input/joystick/analog.c:301:
> > +                               port->axes[j] = (delta(start, time[i]) << ANALOG_FUZZ_BITS) / port->loop;
> 
> Both are cosmetic and I won't be bothered if it were sent to my tree,
> for example ;)  It depends on the maintainer, so if Dmitry wants these
> to be fixed, I'm willing to resubmit, of course.

No, I do not. If there is a large rework we might want to reformat it,
otherwise let's leave it as is.

Thanks.

-- 
Dmitry
