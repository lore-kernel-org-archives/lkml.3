Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaL0TYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 14:24:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaL0TYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 14:24:34 -0500
Date: Sat, 27 Dec 2014 20:24:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Message-ID: <20141227192431.GC10007@amd>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419597294-21487-3-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> which can be used to determine the SoCs temperature. This patch provides
> a DT based driver for the temperature sensor based on an older driver
> written by Peter De Schrijver for the Nokia N900 and N9.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

I did clk_enable -> clk_prepare_enable conversion, as described in
another email.

I got occasional error reading:

root@n900:~# cat /sys/class/hwmon/hwmon0/device/temp_input
20.0
root@n900:~# cat /sys/class/hwmon/hwmon0/device/temp_input
cat: /sys/class/hwmon/hwmon0/device/temp_input: Input/output error
root@n900:~# cat /sys/class/hwmon/hwmon0/device/temp_input
20.0

Nothing in dmesg. It takes few tries to reproduce..

On other attempt, it hung hard:

root@n900:~# cat /sys/class/hwmon/hwmon0/device/temp_input ; cat
/sys/class/hwmon/hwmon0/device/temp_input  ;cat
/sys/class/hwmon/hwmon0/device/temp_input ; cat
/sys/class/hwmon/hwmon0/device/temp_input
17.0
17.0
^[[A



^Z


^C^C^C

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
