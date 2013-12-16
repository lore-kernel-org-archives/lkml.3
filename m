Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab3LPFWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:22:00 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34863 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3LPFV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:21:58 -0500
Date: Sun, 15 Dec 2013 21:21:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Karl Dahlke <eklhad@comcast.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/misc: new PC speaker sounds, clicks and
 notes
Message-ID: <20131216052151.GC4322@core.coreip.homeip.net>
References: <20131109072257.eklhad@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109072257.eklhad@comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karl,

On Mon, Dec 09, 2013 at 07:22:57AM -0500, Karl Dahlke wrote:
> From: Karl Dahlke <eklhad@gmail.com>
> 
> The speaker driver can play a tone at a specified frequency,
> or the standard control G bell,
> which is a special case of TONE at 1000 hz 0.1 seconds.
> This patch adds kd_mkpulse() to generate a soft click.
> This is introduced to support accessibility modules and adapters in the future.
> With this in place, a module can easily provide soft clicks,
> i.e. audible feedback, whenever a key is depressed,
> or when that keystroke is echoed on screen, whichever you prefer.
> (Many people find the latter more valuable.)
> This allows a blind user, for example, to have ongoing feedback while typing,
> even if he is, at the same time, listening to text that is already on screen.
> This is faster and more convenient than having characters echoed verbally.
> And it works all the time, even if speech or braille is not working
> for whatever reason.  And there are many reasons those adapters could fail.
> Misconfigured sound card, bad serial connection,
> software synth not loading, etc.
> Thus these forms of audio feedback are very important.
> 
> This should not be confused with the click function in certain specialized
> keyboards such as lkkbd.c.
> That function does a serio write to the client to activate clicks locally.
> In contrast, this function generates a one-time pulse at the pc speaker,
> or through a similar driver, so that modules can click whenever they want,
> e.g. when a key is echoed back to you by a running application,
> perhaps a thousand miles away over ssh, so you know all is well.
> A module may want to click, or issue a series of clicks, for many reasons.

I do not think it is a good idea to add SND_PULSE as it can be easily
implemented by SND_TONE with the additional benefit that parameters of
the click can be adjusted. Also, if clicking is done elsewhere, it would
work with other speaker drivers besides pcspkr.

> 
> Another function introduced by this patch is kd_mknotes,
> which plays a series of tones in the background.
> You could do this yourself with kd_mksound and timers,
> but why should everyone reinvent the wheel?
> It is better to write the function once, properly, in the kernel,
> and let modules use it thereafter.

Can it be put into a library instead? Especially given David's work on
trying to push the VT code out of the kernel. Also, what if you want
clicks to go through sound card and not the speaker interface?

Thanks.

-- 
Dmitry
