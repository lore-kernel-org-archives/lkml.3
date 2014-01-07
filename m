Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaAGSFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:05:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36735 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaAGSFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:05:11 -0500
Date: Tue, 7 Jan 2014 19:05:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OMAPDSS: DISPC: horizontal timing too tight errors
Message-ID: <20140107180509.GC18316@amd.pavel.ucw.cz>
References: <52CA7ABB.4010401@gmail.com>
 <52CBF476.3070306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CBF476.3070306@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-01-07 14:35:02, Tomi Valkeinen wrote:
> On 2014-01-06 11:43, Ivaylo Dimitrov wrote:
> > Hi,
> > 
> > commit 7faa92339bbb1e6b9a80983b206642517327eb75 "OMAPDSS: DISPC: Handle
> > synclost errors in OMAP3" introduces some limits check to prevent
> > SYNCLOST errors on OMAP3 in a specific usecase. The problem I see here
> > (on Nokia N900, Maemo 5, linux 3.13-rc6, DSP accel video decoding) is
> > that those checks effectively prevent fullscreen video playback of
> > anything above lets say 640x350 with "horizontal timing too tight"
> > errors spit in dmesg log. If I hack check_horiz_timing_omap3 function to
> > always return true, I can happily play videos up to (and including) 720p
> > resolutions, with no SYNCLOST errors.
> 
> I never worked with the patch in question, but my understanding is that
> the core issue is quite difficult to solve optimally for all cases.
> There are so many variables involved. So it may well be that the patch
> in question does it a bit over-safely. Then again, it might as well have
> a bug =).

Can we simply revert 7faa92339bbb1e6b9a80983b206642517327eb75 ?

Working around undocumented problems on unspecified machine, but
breaking configuration people actually use seems like a bad idea.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
