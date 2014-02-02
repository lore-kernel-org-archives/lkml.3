Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaBBSEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 13:04:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55306 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882AbaBBSEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 13:04:40 -0500
Date: Sun, 2 Feb 2014 18:04:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>, Rob Clark <robdclark@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/23]
Message-ID: <20140202180433.GI26684@n2100.arm.linux.org.uk>
References: <cover.1390986082.git.moinejf@free.fr> <20140202124358.GD26684@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140202124358.GD26684@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 12:43:58PM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 29, 2014 at 10:01:22AM +0100, Jean-Francois Moine wrote:
> > This patch set contains various extensions to the tda998x driver:
> > 
> > - simplify the i2c read/write
> > - code cleanup and fix some small errors
> > - use global constants
> > - don't read write-only registers
> > - add DT support
> > - use IRQ for connection status and EDID read
> 
> I discussed these patches with Rob Clark recently, and the conclusion
> we came to is that I'll merge them into a git tree, test them, and
> once I'm happy I'll send a pull request as appropriate.
> 
> I'll go through them later today.  Those patches which have been re-
> posted without any change for the last few times (the first few) I'll
> take into my git tree today so you don't have to keep re-posting them
> (more importantly, I won't have to keep on looking at them either.)

Okay, out of your patches, I would like to queue up the following
for submission into -rc kernels:

drm/i2c: tda998x: fix bad value in the AIF
drm/i2c: tda998x: check the CEC device creation
drm/i2c: tda998x: free the CEC device on encoder_destroy
drm/i2c: tda998x: force the page register at startup time
drm/i2c: tda998x: set the PLL division factor in range 0..3
drm/i2c: tda998x: fix the ENABLE_SPACE register

since these fix real bugs.  Moving them to the front of the queue isn't
that big a deal (I've done it here in my git tree - yes, there were a
few conflicts, but nothing serious.)

I'll also consider these for -rc too:

drm/i2c: tda998x: use HDMI constants
drm/i2c: tda998x: add the active aspect in HDMI AVI frame
drm/i2c: tda998x: change the frequence in the audio channel

if we have reports of display devices affected by the info frame errors.

As far as the last summary line goes, I'll change it to:

	"Use ALSA IEC958 definitions and update audio frequency"

Note that in general, bug fixes should always be towards the beginning
of a patch series, so that they can be applied independently of the
remainder of the development, which also makes them easier to backport
to stable kernels if that's deemed necessary.

As for the remainder, I think moving the DT documentation patch
immediately after the addition of DT code (or even just before it) is
good form.

So, in summary, I'm pretty happy with this again - and it's all been
tested here with no apparant detrimental effects.  All committed and
queued up here:

http://ftp.arm.linux.org.uk/cgit/linux-cubox.git/log/?h=tda998x-devel

If you want to pull it back to check:

  git://ftp.arm.linux.org.uk/~rmk/linux-cubox.git tda998x-devel

I'm proposing to send everything up to the tda998x-fixes tag next week
for 3.13-rc kernels.

Rob, do you want to provide any acks for this or are you happy?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
