Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaJLVTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 17:19:44 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:60602 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaJLVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 17:19:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Workable vintage driver support mechanism? (Re: [alsa-devel] [PATCH v3] ES938 support for ES18xx driver)
Date: Sun, 12 Oct 2014 23:19:04 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Andreas Mohr <andi@lisas.de>, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <1412027079-15876-1-git-send-email-linux@rainbow-software.org> <20141006184150.GA2465@rhlx01.hs-esslingen.de> <s5hr3ykla1p.wl-tiwai@suse.de>
In-Reply-To: <s5hr3ykla1p.wl-tiwai@suse.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201410122319.05127.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 07 October 2014 07:32:18 Takashi Iwai wrote:
> At Mon, 6 Oct 2014 20:41:50 +0200,
>
> Andreas Mohr wrote:
> > On Mon, Oct 06, 2014 at 04:13:12PM +0200, Takashi Iwai wrote:
> > > At Mon, 6 Oct 2014 15:55:18 +0200,
> > >
> > > Ondrej Zary wrote:
> > > > ES938 does not depend on ES18xx and can be connected to any device
> > > > with MIDI interface. Maybe there are some other cards with this chip.
> > >
> > > Please prove it :)
> > >
> > :(
> > :
> > > That said, I'm not willing to merge the patch in the current form.
> > > One of the reason is that this can be implemented pretty easily in
> > > user-space.  Another is that it's a deadly old device, and likely only
> > > handful boards are still running in the world, thus no much motivation
> > > to bloat the kernel code for that.  We're even discussing to get rid
> > > of ISA codes from the kernel tree nowadays.
> > >
> > > Sorry, the patch was submitted 10 years too late.
> > >
> > :((
> >
> > Given that I hate the forces that are increasingly coming into play here
> > (but of course I do see the bigger picture, namely of kernel tree bloat),
> > I think I have an idea which might be useful to accept:
> > for every piece of sufficiently "vintage" submission,
> > people would be tasked with offering (or somehow ensuring)
> > a sufficiently closely time-related cleanup in other places.
> >
> > Thus, given a "diffstat penalty" (lines added minus lines removed)
> > of the vintage support patch:
> >
> > Additionally offer a cleanup patch
> > which gets rid of redundantly implemented kernel tree functionality:
> > - for 15 year old devices: 0.5 * diffstat_penalty
> > - for 20 year old devices: 1.0 * diffstat_penalty
> > - for 25 year old devices: 1.5 * diffstat_penalty
> > - for 30 year old devices: whaaa?
>
> The kernel bloat is one side, and your proposal would help to keep
> figure.  But another side is the maintenance, as Clemens pointed.
> It's obviously more difficult for exotic hardware devices.  So, it's
> really case-by-case.
>
> Speaking of this particular patch, however, the reason for NAK isn't
> (only) the vintage.  There are other concerns as I raised, especially
> the ugliness of the interface it uses, and this doesn't have to be a
> kernel stuff at all.  You could implement it as a user-space alsa-lib
> plugin as well.

So do I understand correctly that there is no (right) way for a kernel driver 
to issue MIDI commands?

Is it possible for an alsa-lib plugin to automatically load when an ES18xx 
sound card is present to check for ES938 (without repeating the detection on 
each application launch)?

-- 
Ondrej Zary
