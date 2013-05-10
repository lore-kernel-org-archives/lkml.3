Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3EJKyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:54:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40630 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3EJKyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:54:50 -0400
Date: Fri, 10 May 2013 12:54:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Len Brown <len.brown@intel.com>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 0/3] pm: Introduce __pm to mark power management code
Message-ID: <20130510105446.GA6107@amd.pavel.ucw.cz>
References: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-05-09 10:09:48, Guenter Roeck wrote:
> The following patch series introduces a marker for power management functions
> and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
> can be removed from most of the code. This ensures that the conditional code
> still compiles but is not included in the object file.

Was it compile-tested for both PM_SLEEP and !PM_SLEEP cases?

If driver wants to have pm-specific fields in its structures, this
will make it harder.

Ifdefs are ugly, and this has better compiler coverage in !PM_SLEEP
case. Good. OTOH most people are running with PM_SLEEP, so advantage
is not great...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
