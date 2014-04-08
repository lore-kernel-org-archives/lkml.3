Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaDHJTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:19:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59819 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaDHJTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:19:44 -0400
Date: Tue, 8 Apr 2014 11:19:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Laszlo Papp <lpapp@kde.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Tachometer speed returned rather than absolute
 fan speed?
Message-ID: <20140408091943.GA14642@amd.pavel.ucw.cz>
References: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
 <20140307162524.6abd34be@endymion.delvare>
 <CAOMwXhOB=1HA57jwKCx3-hU8A_ypjrm0J3R9huO25xa4B_gw8w@mail.gmail.com>
 <20140307163717.336873f5@endymion.delvare>
 <CAOMwXhPpObWqd1vR3t+ifKd-_ZbnGTm1TNNUakmVAR3CB=pzTg@mail.gmail.com>
 <20140307181718.GA1027@roeck-us.net>
 <531BACD9.9050206@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531BACD9.9050206@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-03-08 15:50:49, Guenter Roeck wrote:
> On 03/07/2014 10:17 AM, Guenter Roeck wrote:
> >On Fri, Mar 07, 2014 at 03:47:08PM +0000, Laszlo Papp wrote:
> >>On Fri, Mar 7, 2014 at 3:37 PM, Jean Delvare <jdelvare@suse.de> wrote:
> >>>>>I'm quite confused. While I admit that the term "tachometer speed" is
> >>>>>awkward, the max6650 driver is reporting fan speeds in RPM as every
> >>>>>other hwmon driver. So I really have no idea what you think is wrong.
> >>>>>What did you think "tachometer speed" was, if not the fan speed? Does
> >>>>>the max6650 driver not return correct fan speeds for you?
> >>
> >>That is some strange behavior. If I do "echo 1 > pwm1_enable; echo 0 >
> >>pwm1; cat fan1_input", I still see 30 for the connected fan, whereas I
> >>can see it stopped. Is this an expected behavior? I would expect zero
> >>as a user.
> >>
> >I seem to recall that I had seen that as well, with no fan connected.
> >Maybe the tachometer registers always read at least '1'. I would think
> >it is wrong, but we'll have to understand the chip a bit better
> >to be able to provide a fix. Unless you already have a fix ready,
> >of course. I'll try to re-test tonight if I find the time.
> >
> 
> The reason is (most likely) that your fan input does not have a pull-up
> resistor. Per datasheet, the fan inputs need a 10kOhm pull-up resistor.
> I confirmed this with my test board - with the pull-up resistor,
> inputs read 0, Without pull-up, the reported value is 1, which
> translates to 30 RPM.

While this is hardware problem, it might make sense for kernel to work
around it -- return 0 in case 30 RPM observed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
