Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3JHVeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:34:36 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64964 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3JHVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <20131008210712.GC16883@shells.gnugeneration.com>
References: <20131008210712.GC16883@shells.gnugeneration.com>
Date: Tue, 8 Oct 2013 14:34:33 -0700
Message-ID: <CAK2H+ee4GJkvu-TLN6exx=aSvoA9rs=bt-NC02N9+gm=FND8pA@mail.gmail.com>
Subject: Re: snd_hda_intel headphone output disabling upon complete insertion
 of plug
From: Mark Knecht <markknecht@gmail.com>
To: lkml@pengaru.com
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 2:07 PM,  <lkml@pengaru.com> wrote:
> Hello list,
>
> Somewhere between 3.11.0-rc7-gfa8218d and 3.12.0-rc4-g8b5ede6 this
> broke.
>
> The machine is an x61s thinkpad, with the headphone output unmuted and
> headphones partially inserted sound is audible.  If the output is muted,
> the output shuts off.  With the output unmuted, upon inserting the
> headphone plug fully the output shuts off following a blink of a delay.
> If I slowly remove the headphone plug returning it to a partially inserted
> state, the audio returns after another delay.
>
> It seems like a bug in the headphone amplifier power management, as if
> it's doing the inverse of what it needs to do.  I'll try find time to
> bisect, just wanted to get this out there though in case any of you
> recognize the problem and know what might have caused it.
>
> Regards,
> Vito Caputo

Sometimes across kernel revisions I've had problems like this.
(Although not that specific one!) It seems that the asound.state file
format changes and alsa renumbers their internal controls. You might
try saving the existing file elsewhere and then setting up alsa again
from scratch. That solved my last problem of that type.

HTH,
Mark
