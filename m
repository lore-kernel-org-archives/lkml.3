Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752Ab3EFXQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:16:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55497 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406Ab3EFXQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:16:20 -0400
Date: Tue, 7 May 2013 01:16:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
Message-ID: <20130506231554.GB16801@amd.pavel.ucw.cz>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
 <1367602547-19322-2-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367602547-19322-2-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Now that we support a timer-backed delay loop, I'm quickly getting sick
> and tired of people complaining that their beloved bogomips value has
> decreased. You know who you are!

> Unfortunately, we can't just remove the entry from /proc/cpuinfo, as it
> will likely break fragile userspace code which is parsing that stuff, so
> instead replace it with a dummy value that can be chosen in the
> Kconfig.

So, instead of removing it you silently report invalid value? Note
that there's no cpumhz display in procinfo... at least on OLPC I
looked.

And whether it is 30MHz or 3GHz cpu might be relevant information for
userspace, and yes, bogomips used to be good enough for that.

Actually it was mhz, mhz/2 or mhz*2 on pretty much all reasonable systems.

> +choice
> +	prompt "BogoMIPs setting"
> +	default BOGOMIPS_MEDIUM
> +	help
> +	  The BogoMIPs value reported by Linux is exactly what it sounds
> +	  like: totally bogus. It is used to calibrate the delay loop,
> +	  which may be backed by a timer clocked completely independently
> +	  of the CPU.

This is too ugly to live, sorry.

> +	config BOGOMIPS_SLOW
> +		bool "Slow (older machines)"
> +		help
> +		  If you're comparing a faster machine with a slower machine,
> +		  then you might want this option selected on one of them.
> +
> +	config BOGOMIPS_MEDIUM
> +		bool "Medium (default)"
> +		help
> +		  A BogoMIPS value for the masses.
> +
> +	config BOGOMIPS_FAST
> +		bool "Fast (marketing)"
> +		help
> +		  Some people believe that software runs faster with this
> +		  setting so, if you're one of them, say Y here.

April 1st came late this year?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
