Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3IWQqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:46:47 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43569 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IWQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:46:44 -0400
X-Originating-IP: 83.160.107.163
Date: Mon, 23 Sep 2013 18:46:37 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Take touchscreen channels into
 account for conversion timeout
Message-ID: <20130923164637.GF27515@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
	Felipe Balbi <balbi@ti.com>,
	Pantelis Antoniou <panto@antoniou-consulting.com>,
	linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f1830a7d0debce351966d2f3232158313d87dcc0.1378846446.git.matthias@kaehlcke.net>
 <20130910210228.GC30481@raspi>
 <524042A2.2070005@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524042A2.2070005@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

El Mon, Sep 23, 2013 at 03:31:14PM +0200 Sebastian Andrzej Siewior ha dit:

> On 09/10/2013 11:02 PM, Matthias Kaehlcke wrote:
> > The calculation of the old conversion timeout value was based on the number of
> > channels used by this driver. This doesn't take into account that other channels
> > can be used by the touchscreen driver. Adjust the timeout value to the maximum
> > if the touchscreen driver is enabled
> 
> What bug / miss behave are you trying to fix?

I ran into timeouts when using the touchscreen driver at the same time
as the general purpose ADC and reviewed the timeout calculations. I found
that the IDLE_TIMEOUT value is/was wrong (I submitted another patch
for this) and that the ADC driver doesn't take into account the
steps used by the touchscreen driver

> The difference in timming is minimal and therefore I would prefer to get
> rid of this ifdef and assume the max value of those two instead.

Jonathan also expressed his concerns about this, I submitted a
follow-up patch without the ifdef (https://lkml.org/lkml/2013/9/16/460).
I would appreciate your comments on this patch

note that the timing difference isn't that minimal with the correct
IDLE_TIMEOUT (~100us instead of 10us), it sums up to a max timeout of
~1.6ms (16 steps) and we are busy looping (though in the non-error
case we will bail out as soon as the conversion cycle is finished)

best regards

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

    In the absence of clearly-defined goals, we become strangely loyal to
      performing daily trivia until ultimately we become enslaved by it
                           (Robert Heinlein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
