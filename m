Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbaDJLiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:38:54 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:58173 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935486AbaDJLiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:38:51 -0400
X-AuditID: cbfec373-b7f4a6d000005e0a-bc-534682c9f5d2
Date: Thu, 10 Apr 2014 08:38:41 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: shuah.kh@samsung.com, Greg KH <gregkh@linuxfoundation.org>, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
Message-id: <20140410083841.488f9c43@samsung.com>
In-reply-to: <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <20140409191740.GA10748@kroah.com> <5345CD32.8010305@samsung.com>
 <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/hEN2TTW7BBr+uyVtMmvKXzaJ58Xo2
	i8u75rBZ9GzYymrxZOEZJovHK96yW3z5zGXx9aeDxa/lRxkttt1ayOLA5bFz1l12j13bdjJ5
	LN7zkslj06pONo/9c9ewe7Se3MTqsfN7A7tH35ZVjB6fN8kFcEZx2aSk5mSWpRbp2yVwZRx6
	9Ju54Bd3xemnz1kbGGdydjFyckgImEgs2ribDcIWk7hwbz2YLSSwhFFiyxm9LkYuILuPSeJb
	91VGkASLgKrE+svLmEBsNgEjiVeNLawgtgjQoOZXrxlBGpgFnjBK7P55ASwhLGAjsf/aFRYQ
	m1fAUOJA0y+wOKeAncTcazOYITasZ5TYsOAYK8QZThKvXk9mgmgQlPgx+R5YM7OAlsTmbU2s
	ELa8xOY1b5knMArMQlI2C0nZLCRlCxiZVzGKlhYnFxQnpeca6RUn5haX5qXrJefnbmKExErx
	DsYXG6wOMQpwMCrx8B5Y5hosxJpYVlyZe4hRgoNZSYQ3r9ItWIg3JbGyKrUoP76oNCe1+BAj
	EwenVAOjlJTbkvzHDE6+xstjXO4JSUXE5vDt7HEwVOOUv7A0a2XtBbtEnqUJ/CueVx2yN1Gv
	ufb5g+yZgjatLd5Hls+onBm//0++2IL34t+MxLbnRSn2VfNOkRdZzs+V/GR+5YxtSjOO/mWc
	VZMpvG9Zr3ZhW0R/b+xXuaxio6q2ADdj0yOGU/5tn63EUpyRaKjFXFScCABWckktcwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Em Thu, 10 Apr 2014 12:04:35 +0100
One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> escreveu:

> > >>   - Construct string with (dev is struct em28xx *dev)
> > >> 		format: "tuner:%s-%s-%d"
> > >> 		with the following:
> > >>     	            dev_name(&dev->udev->dev)
> > >>                  dev->udev->bus->bus_name
> > >>                  dev->tuner_addr
> 
> What guarantees this won't get confused by hot plugging and re-use of the
> bus slot ?

Good point. Yes, this should be addressed.

> I'm also not sure I understand why you can't have a shared parent device
> and simply attach the resources to that. This sounds like a problem mfd
> already solved ?

There are some devices that have lots of different functions spread
out on several subsystems.

For example, some devices provide standard USB Audio Class, handled by
snd-usb-audio for the audio stream, while the video stream is handled
via a separate driver, like some em28xx devices.

There are even more complex devices that provide 3G modem, storage
and digital TV, whose USB ID changes when either the 3G modem starts
or when the digital TV firmware is loaded.

So, we need to find a way to lock some hardware resources among
different subsystems that don't share anything in common. Not sure if
mfd has the same type of problem of a non-mfd driver using another
function of the same device that has some shared hardware resources
between the separate functions, and, if so, how they solved it.

Regards,
Mauro
