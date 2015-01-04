Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbbADUnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:43:42 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42972 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752778AbbADUnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:43:40 -0500
Date: Sun, 4 Jan 2015 20:43:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150104204323.GA12302@n2100.arm.linux.org.uk>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 12:22:36PM -0800, Linus Torvalds wrote:
> On Sun, Jan 4, 2015 at 12:03 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >
> > NAK.
> 
> To quote the standard response for people who ignore regressions:
> 
>   "SHUT THE FUCK UP"
> 
> you cannot NAK regression fixes. Seriously.

How about we calm down and take some informed view instead of throwing
mud?  I'd never thought I'd have to be doing this but it seems necessary.

Yes, it's bad that we now have a userspace breakage from removing the
bogomips, but a simple revert of the patch doesn't fix it properly.  It
_may_ seem to get things going again by providing a value, but that
value may not be what was once provided back in the days that these
programs were written.

The problem is that we now have hardware timers providing the kernel's
delay implementation, which makes the published "bogomips" value no
longer meaningful for the CPU speed.

So, merely reverting the patch doesn't fix the problem.  So, Nico's
NAK on the simple revert is quite right.

Instead of throwing insults, what we need to do is to approach this
calmly, and work out what we can do to fix it properly.

I'm *not* going to be looking at this until at least mid-week because
I'm still on my Christmas break, but also I'm unwell which has left me
severely lacking sleep.  If others want to do all the necessary
research, then be my guest.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
