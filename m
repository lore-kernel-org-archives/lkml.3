Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbbAFWIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:08:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46345 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbbAFWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:08:07 -0500
Date: Tue, 6 Jan 2015 23:08:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Felipe Balbi <balbi@ti.com>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106220805.GD13902@amd>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205730.GA6071@fuloong-minipc.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106205730.GA6071@fuloong-minipc.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-06 22:57:30, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, Jan 06, 2015 at 09:50:00PM +0100, Pavel Machek wrote:
> > PS: Unfortunately, N900 will not boot using nfsroot in 3.16+ at least,
> > and boot from MMC card is broken and has been for quite some time.
> 
> USB networking works fine with 3.19-rc3 and also MMC card rootfs.

Does nfsroot work for you? USB networking works as a module but not
build-in. [Patch is available for this one.]

u-SD card seems to have similar problem. If I try it after boot, I can
access it ok, but using u-SD card for rootfs fails. If it works for
you, it would be interesting to know.

I'm loading zImage using 0xffff directly from the PC.

For the audio: this should do the trick:


root@n900:~# uname -a
Linux n900 3.18.0-omap3-69644-g0ed746d #837 PREEMPT Sun Jan 4 22:30:24
CET 2015 armv7l GNU/Linux
root@n900:~# alsactl init
Found hardware: "RX-51" "" "" "" ""
Hardware is initialized using a generic method
root@n900:~# cat /etc/debian_version
7.7
root@n900:~# mplayer /my2/*

(audio actually works).

I do have Pali's n900 changes applied. I guess I should try without
them. Let me know if .config would help you.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
