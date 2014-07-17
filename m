Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaGQGBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:01:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaGQGBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:01:52 -0400
Message-ID: <1405576908.27806.10.camel@linux-fkkt.site>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
From: Oliver Neukum <oneukum@suse.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bastien Nocera <hadess@hadess.net>, Patrik Fimml <patrikf@chromium.org>,
        linux-pm@vger.kernel.org, Dmitry Torokhov <dtor@google.com>,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 08:01:48 +0200
In-Reply-To: <1463038.d2xocpRFLY@vostro.rjw.lan>
References: <20140716013206.GA13409@google.com>
	 <5611777.bNi5p029gt@vostro.rjw.lan> <1405552422.17757.5.camel@nuvo>
	 <1463038.d2xocpRFLY@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 01:33 +0200, Rafael J. Wysocki wrote:
> On Thursday, July 17, 2014 01:13:42 AM Bastien Nocera wrote:

> > Applications can already check the lid status (through UPower), and with
> > the additional metadata from the kernel, know that the webcam won't be
> > usable when the lid is closed. Switching to external webcam, a webcam on
> > the outside of the case, or switch off the video stream would then be
> > the expected behaviour.
> 
> Well, is the scenario I described correct or not?  If not, then what
> exactly is the scenario you want to be able to handle?

Well, I think you need to add that you want user space to tell the
kernel that devices should not do remote wakeup under some conditions.
And I think this should not be limited to lid closure. And thus it
does not belong into the kernel.

A good example would be mice. From the kernel side runtime power
management works just fine. In practice it is rarely usable because
remote wakeup doesn't work well enough in common mice. It would
be good enough if the screen saver were working.

So I think lacking is the ability to model that remote wakeup
capabilities are

- dependent on external events
- binary capable or incapable

And we might introduce a system similar to rfkill that tells
devices that they are useless and hence idle due to external factors
(the internal webcam, keyboard, touchscreen ...)
Putting this into user space is difficult because you cannot really
fully close a keyboard.

	Regards
		Oliver


