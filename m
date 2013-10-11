Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3JKQqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:46:54 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:49871 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751951Ab3JKQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:46:53 -0400
Date: Fri, 11 Oct 2013 11:46:51 -0500
From: lkml@pengaru.com
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: snd_hda_intel headphone output disabling upon complete insertion of plug
Message-ID: <20131011164651.GE6881@shells.gnugeneration.com>
References: <20131008210712.GC16883@shells.gnugeneration.com> <CAK2H+ee4GJkvu-TLN6exx=aSvoA9rs=bt-NC02N9+gm=FND8pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK2H+ee4GJkvu-TLN6exx=aSvoA9rs=bt-NC02N9+gm=FND8pA@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 02:34:33PM -0700, Mark Knecht wrote:
> On Tue, Oct 8, 2013 at 2:07 PM,  <lkml@pengaru.com> wrote:
> > Hello list,
> >
> > Somewhere between 3.11.0-rc7-gfa8218d and 3.12.0-rc4-g8b5ede6 this
> > broke.
> >
> > The machine is an x61s thinkpad, with the headphone output unmuted and
> > headphones partially inserted sound is audible.  If the output is muted,
> > the output shuts off.  With the output unmuted, upon inserting the
> > headphone plug fully the output shuts off following a blink of a delay.
> > If I slowly remove the headphone plug returning it to a partially inserted
> > state, the audio returns after another delay.
> >
> > It seems like a bug in the headphone amplifier power management, as if
> > it's doing the inverse of what it needs to do.  I'll try find time to
> > bisect, just wanted to get this out there though in case any of you
> > recognize the problem and know what might have caused it.
> >
> > Regards,
> > Vito Caputo
> 
> Sometimes across kernel revisions I've had problems like this.
> (Although not that specific one!) It seems that the asound.state file
> format changes and alsa renumbers their internal controls. You might
> try saving the existing file elsewhere and then setting up alsa again
> from scratch. That solved my last problem of that type.
> 

NAK, has no effect.  Looking at the diff between the revisions under
sound/pci/hda there appears to be quite a bit of activity.  Hopefully I
can get around to bisecting this weekend.  Leaving the headphones 90%
inserted is workable for now.

Regards,
Vito Caputo
