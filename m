Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbbA2BjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:39:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36828 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbbA2BjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:39:08 -0500
Date: Wed, 28 Jan 2015 23:02:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        jarkko.nikula@bitmer.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150128220253.GB28275@amd>
References: <20150106170433.GA5408@amd>
 <20150118120139.GA1509@amd>
 <54C63F1C.6010703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C63F1C.6010703@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-26 15:20:28, Peter Ujfalusi wrote:
> On 01/18/2015 02:01 PM, Pavel Machek wrote:
> > Hi!
> > 
> > If you have any idea about playback problems, help would be still
> > welcome. I'll have to do bisect, otherwise, and it will not be easy.
> > 
> >> In 3.18, sound is nice and clear.
> >>
> >> In 3.19, sound is unusable. It produces nasty tone when it should be
> >> quiet, and there's at least as much noise as is sound.
> >>
> >> Unfortunately, list of mixers also changed (and there's cca 120
> >> settings), but a) it does not work with the old list and b) nothing I
> >> could figure out did make the sound usable. Some setting resulted in
> >> even more noise.
> >>
> >> Any idea what could have caused it?
> > 
> > I tried audio recording this time.
> > 
> > In 2.6.28-nokia, it is neccessary to set "Input select" na "digital
> > mic", then it works. Input select being in "playback" option makes it
> > easy to miss.
> > 
> > In 3.18 and 3.19-rc3, all I can record are zeros.
> > 
> > Does playback/recording work for you on OMAP 3430-based machines?
> 
> Same codec (tlv320aic3106) works fine on my am335x and omap-l138 boards.
> BeagleBoard-xM also fine with twl4030 codec.
> 
> I don't have my n900 in hacking mode (it is still in use
> time-to-time) but

Actually, with nfsroot / loading kernel using NOLO, it is not
neccessary to break your n900. It is possible to boot complete
userspace without changing single bit of flash.

> looking at the dts file: you might want to add ai3x-micbias-vg property to the
> aic3x nodes to select the correct mic bias voltage. I can't recall what is
> appropriate for n900, but 2.6.28-nokia sources might give you the answer.

Ok, thanks, let me try...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
