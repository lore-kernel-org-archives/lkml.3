Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbaLKPw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:52:58 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46332 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932946AbaLKPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:52:56 -0500
Date: Thu, 11 Dec 2014 17:52:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH/RFC v9 08/19] leds: Add driver for AAT1290 current
 regulator
Message-ID: <20141211155222.GU15559@valkosipuli.retiisi.org.uk>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-9-git-send-email-j.anaszewski@samsung.com>
 <20141211141648.GR15559@valkosipuli.retiisi.org.uk>
 <5489B995.7080209@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5489B995.7080209@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Thu, Dec 11, 2014 at 04:34:45PM +0100, Jacek Anaszewski wrote:
> >>+
> >>+	/* write address */
> >>+	for (i = 0; i < addr; ++i) {
> >>+		udelay(AAT1290_EN_SET_TICK_TIME_US);
> >>+		gpio_set_value(led->en_set_gpio, 0);
> >>+		udelay(AAT1290_EN_SET_TICK_TIME_US);
> >>+		gpio_set_value(led->en_set_gpio, 1);
> >>+	}
> >
> >This is a very interesting approach to bus implementation. It's a bit like
> >pulse dial on POTS. :-)
> >
> >>+
> >>+	udelay(AAT1290_LATCH_TIME_US);
> >
> >How precise does this need to be? Could you use usleep_range() instead?
> 
> This is minimal required time, so usleep_range could be used here,
> which would however make the delay of setting the torch brightness
> even more unstable.

True as well. Half a ms isn't that long but then again torch typically isn't
time critical either. I'd use usleep_range(), up to you.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
