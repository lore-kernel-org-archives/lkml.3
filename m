Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3IORuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:50:09 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40834 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3IORuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:50:07 -0400
X-Originating-IP: 83.160.107.163
Date: Sun, 15 Sep 2013 19:50:00 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Take touchscreen channels into
 account for conversion timeout
Message-ID: <20130915175000.GA24058@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Felipe Balbi <balbi@ti.com>,
	Pantelis Antoniou <panto@antoniou-consulting.com>,
	linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f1830a7d0debce351966d2f3232158313d87dcc0.1378846446.git.matthias@kaehlcke.net>
 <20130910210228.GC30481@raspi>
 <5235DD9A.5040700@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5235DD9A.5040700@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

thanks for your comments

El Sun, Sep 15, 2013 at 05:17:30PM +0100 Jonathan Cameron ha dit:

> On 09/10/13 22:02, Matthias Kaehlcke wrote:
> > The calculation of the old conversion timeout value was based on the number of
> > channels used by this driver. This doesn't take into account that other channels
> > can be used by the touchscreen driver. Adjust the timeout value to the maximum
> > if the touchscreen driver is enabled
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> Hmm... This is a bit of an uggly solution.  Can we do anything neater via some
> callbacks in the underlying mfd?

i agree, it isn't a very elegant solution. as it's a max timeout which
should never be hit i thought it might be good enough. using a
callback in the mfd is feasible, the mfd has information about the
number of steps used by the touchscreen driver. i'll send a reworked
version soon

thanks

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

             "The only important thing Windows does better
            than Debian is implementing the win32 platform"
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
