Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab3KAEWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 00:22:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:60372 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3KAEWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 00:22:45 -0400
Message-ID: <1383279744.28909.26.camel@pasglop>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 01 Nov 2013 15:22:24 +1100
In-Reply-To: <20131101145925.66e22f73@notabene.brown>
References: <20131101145925.66e22f73@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 14:59 +1100, NeilBrown wrote:
> and I wonder how relevant it still is in this context.  As platform devices
> are all in the root of the device-tree and hence are siblings, they must have
> unique names in the device-tree and  so the platform devices created from
> them will also have unique names -- won't they?

I agree about /sys/devices -> /sys/devices/platform, that makes more
sense

The problem with names is that we don't *know* that your devices are
at the root and unique. They don't have to be. I have platforms that
have several "chips" each containing all the same devices. They need to
be de-duped.

Maybe the right approach is to build the de-duplication in sysfs
itself ?

Cheers,
Ben.

> Any help understanding and/or fixing this discrepancy greatly appreciated.
> 
> The change of name is particularly annoying to me because one of my platform
> devices is a pwm_bl.c backlight.  With a boardfile I
> get /sys/class/pwm_backlight.  With devicetree the best I can get
> is /sys/class/pwm_backlight.23 (or similar).  It would be really nice to have
> a more stable and sensible name here.


