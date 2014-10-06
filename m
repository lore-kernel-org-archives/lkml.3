Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaJFUpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:45:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57196 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJFUp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:45:29 -0400
Date: Mon, 6 Oct 2014 22:45:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: 3.17-rc5: kernel oops when exiting X under heavy load
Message-ID: <20141006204526.GA28905@amd>
References: <20141003231109.GA4530@amd>
 <20141006181202.GA22781@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006181202.GA22781@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > From the backtrace, it looks evdev related...?
> 
> Hmm, looks like it...

I don't think I can repeat that. I was doing crazy stuff at that
moment. (Typo fixes suggested below).

Thanks,
								Pavel

Input: evdev - fix EVIOCG{type} ioctl

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The 'max' size passed into the function is measured in number of bits
(KEY_MAX, LED_MAX, etc) so we nedd to convert it accoidingly before tyring

###                           need               accordingly(?)     trying

to copy the data out, otherwise we will try copying too much and end up
with up with a page fault.

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
