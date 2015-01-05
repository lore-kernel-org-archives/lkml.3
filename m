Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbbAEPem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:34:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33518 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbAEPel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:34:41 -0500
Date: Mon, 5 Jan 2015 16:34:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150105153437.GB3433@amd>
References: <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd>
 <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
 <20150104203724.GA16372@amd>
 <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
 <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <20150105121126.GA10116@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105121126.GA10116@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-05 12:11:36, Will Deacon wrote:
> Hi all,
> 
> Sorry for the late reply, it seems that neither myself or the
> arm-linux-kernel list were on CC for this thread.

Sorry about that. I was pretty sure I cc-ed you, but apparently did
not.

> Pavel: do you have something we can run to observe the problem?

Debian 7.7: mpg123, anything pyaudio based, at least. (install
python-pyaudio, try to run examples).

I hit it with:

#!/usr/bin/env python
# Written by Yu-Jie Lin
# Public Domain
#
# Deps: PyAudio, NumPy, and Matplotlib
# Blog:
# http://blog.yjl.im/2012/11/frequency-spectrum-of-sound-using.html

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import pyaudio
import struct
import wave
...

When I decided to investigate.

> Finally, the revert doesn't have a Cc stable tag which is probably needed
> if it's going to land in 3.19 final, irrespective of whether we agree that
> it's the right way forward.

Yes, pushing is to stable is good idea. Will you take care?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
