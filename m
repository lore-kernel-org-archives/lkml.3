Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3GEUxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:53:11 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:53930 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750937Ab3GEUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:53:09 -0400
Date: Fri, 5 Jul 2013 22:53:07 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-watchdog@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: modalias char-major-10-130
Message-ID: <20130705205307.GB14258@spo001.leaseweb.com>
References: <1372854803.22042.22.camel@chaos.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372854803.22042.22.camel@chaos.site>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

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

You have a valid point: There were we have modaliases and other detection
mechanism we should indeed remove them. The rest should be evaluated
afterwards on a case by case basis. Certain intel based drivers should
(like advantechwdt) should indeed be fixed because they poke in the hardware
directly and can't be really detected.

Kind regards,
Wim.

