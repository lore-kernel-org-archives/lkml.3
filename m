Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3LaTDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:03:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52751 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3LaTDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:03:06 -0500
Date: Tue, 31 Dec 2013 20:03:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Joe Xue <lgxue@hotmail.com>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add LED pattern trigger
Message-ID: <20131231190304.GA15451@amd.pavel.ucw.cz>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
 <20131230183302.GA28430@amd.pavel.ucw.cz>
 <BLU172-W18A7B97F4E688F416C5DABACC90@phx.gbl>
 <20131231113352.GA4233@amd.pavel.ucw.cz>
 <CAFLxGvy31K9cgiuQKPmcbbr8QpMmj3vxmA1opNWT01qDUaLR0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvy31K9cgiuQKPmcbbr8QpMmj3vxmA1opNWT01qDUaLR0Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-12-31 13:29:21, Richard Weinberger wrote:
> On Tue, Dec 31, 2013 at 12:33 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Tue 2013-12-31 00:00:39, Joe Xue wrote:
> >> > What about something like this?
> >> >
> >> > Not shcheduling timer when nothing changed should save a bit of power/cpu...
> >> >
> >> > if (pattern_data->pattern[pattern_data->count] == '/') {
> >> > return;
> >> > }
> >> >
> >> > this = pattern_data->pattern[pattern_data->count]
> >> > if (this == '#')
> >> > new_brigtness = pattern_data->brightness_on;
> >> > if (this == ' ')
> >> > new_brigtness = LED_OFF;
> >> > repeat = 1;
> >> > while (pattern_data->pattern[pattern_data->count + repeat] == this)
> >> > repeat++;
> >> >
> >> > mod_timer(&pattern_data->timer,
> >> > jiffies + msecs_to_jiffies(pattern_data->delay_unit * repeat));
> >> >
> >> >
> >> Working on it.
> >>
> >> Thanks for your help.
> >
> > You are welcome :-).
> 
> Why do we need this within the kernel?
> Patterns can easily created using a simple user space program.

Some machines (N900) can do blinking in hardware, and we want
consistent kernel-user interface. See the mailing list.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
