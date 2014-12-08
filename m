Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaLHUTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:19:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49784 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLHUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:18:59 -0500
Date: Mon, 8 Dec 2014 21:18:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
Message-ID: <20141208201855.GA16648@amd>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd>
 <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd>
 <547C7420.4080801@samsung.com>
 <CAK5ve-KMNszyz6br_Q_dOhvk=_8ev6Uz-ZhPnYBn-ZvuohQpVA@mail.gmail.com>
 <20141206124310.GB3411@amd>
 <5485D7F8.10807@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5485D7F8.10807@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-12-08 17:55:20, Jacek Anaszewski wrote:
> On 12/06/2014 01:43 PM, Pavel Machek wrote:
> >
> >>>The format of a sysfs attribute should be concise.
> >>>The error codes are generic and map directly to the V4L2 Flash
> >>>error codes.
> >>>
> >>
> >>Actually I'd like to see those flash fault code defined in LED
> >>subsystem. And V4L2 will just include LED flash header file to use it.
> >>Because flash fault code is not for V4L2 specific but it's a feature
> >>of LED flash devices.
> >>
> >>For clearing error code of flash devices, I think it depends on the
> >>hardware. If most of our LED flash is using reading to clear error
> >>code, we probably can make it simple as this now. But what if some
> >>other LED flash devices are using writing to clear error code? we
> >>should provide a API to that?
> >
> >Actually, we should provide API that makes sense, and that is easy to
> >use by userspace.
> >
> >I believe "read" is called read because it does not change anything,
> >and it should stay that way in /sysfs. You may want to talk to sysfs
> >maintainers if you plan on doing another semantics.
> 
> How would you proceed in case of devices which clear their fault
> register upon I2C readout (e.g. AS3645)? In this case read does have
> a side effect. For such devices attribute semantics would have to be
> different than for the devices which don't clear faults on readout.

No, semantics should be same for all devices.

If device clears fault register during I2C readout, kernel will simply
gather faults in an variable, and clear them upon write to sysfs file.

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
