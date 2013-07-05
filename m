Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3GERSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:18:24 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:53407 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab3GERSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:18:23 -0400
Date: Fri, 5 Jul 2013 10:18:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: modalias char-major-10-130
Message-ID: <20130705171824.GB29175@roeck-us.net>
References: <1372854803.22042.22.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372854803.22042.22.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 02:33:23PM +0200, Jean Delvare wrote:
> Hi Wim,
> 
> All watchdog drivers include:
> 
> MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> 
> which causes a modalias char-major-10-130 to be added to every watchdog
> driver module. As a result, any access to /dev/watchdog on a system with
> no watchdog driver loaded and working will result in an attempt to load
> several dozen drivers. At best one or two will actually work, the others
> will:
> 
> * Waste time failing to load.
> * Waste memory succeeding to load but not finding any device to bind to.
> * Pollute the kernel log.
> * Sometimes even load while they should not and break the system. I just
> had a report about advantechwdt doing that on some systems.
> 
> And the attempt order will presumably be random, so it might as well
> load softdog before a hardware-based watchdog which would have been
> preferred.
> 
> This looks so 90s. Drivers for enumerated devices have hardware-based
> modaliases, so char-major-10-130 shouldn't be needed. Other drivers
> should certainly not be loaded randomly if they need to poke the
> hardware to detect the presence of a supported device.
> 
> My opinion is that the char-major-10-130 modalias should ONLY be defined
> by user-space, when the user knows he/she needs a watchdog driver which
> doesn't support auto-loading via hardware-based auto-loading.
> 
> So, can we please get rid of all these
> MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) statements? They do more harm than
> good as far as I can see.
> 
Agreed.

Can you submit a set of patches ? I'll be happy to add my Reviewed-by: tag
to it. Of course that won't guarantee acceptance ;).

Thanks,
Guenter
