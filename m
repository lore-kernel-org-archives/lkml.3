Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaJVKVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:21:54 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:60333 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaJVKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:21:52 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 22 Oct 2014 12:18:49 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, nsekhar@ti.com,
        t-kristo@ti.com, j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] rtc: omap: add support for pmic_power_en
Message-ID: <20141022101849.GL2113@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-10-git-send-email-johan@kernel.org>
 <20141010180721.GV31348@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010180721.GV31348@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:07:27PM -0500, Felipe Balbi wrote:
> On Thu, Oct 09, 2014 at 09:06:31PM +0200, Johan Hovold wrote:

> > -	/* clear pending irqs, and set 1/second periodic,
> > -	 * which we'll use instead of update irqs
> > +	/*
> > +	 * disable interrupts
> > +	 *
> > +	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is used
> >  	 */
> > -	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
> > +	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);
> 
> bug fix, should be part of a separate patch and Cc stable :-)

I made this a separate fix in v2 but did not mark it for stable for now
as no one has been bitten by it (ALARM2 is never enabled by the current
driver).

Johan
