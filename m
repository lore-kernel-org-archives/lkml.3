Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaKHB0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:26:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64143 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752442AbaKHB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:26:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>, Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [PATCH] PM / Hibernate: Migrate to ktime_t
Date: Sat, 08 Nov 2014 02:47:29 +0100
Message-ID: <2442680.y0UEcXlDY6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3436721.isgG5Fql2m@wuerfel>
References: <20141030180453.GA55907@localhost> <3436721.isgG5Fql2m@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 30, 2014 08:08:17 PM Arnd Bergmann wrote:
> On Thursday 30 October 2014 11:04:53 Tina Ruchandani wrote:
> > This patch migrates swsusp_show_speed and its callers to using ktime_t instead
> > of 'struct timeval' which suffers from the y2038 problem.
> > 
> > Changes to swsusp_show_speed:
> >         - use ktime_t for start and stop times
> >         - pass start and stop times by value
> > Calling functions affected:
> >         - load_image
> >         - load_image_lzo
> >         - save_image
> >         - save_image_lzo
> >         - hibernate_preallocate_memory
> > Design decisions:
> >         - use ktime_t to preserve same granularity of reporting as before
> >         - use centisecs logic as before to avoid 'div by zero' issues caused by
> >           using seconds and nanoseconds directly
> >         - use monotonic time (ktime_get()) since we only care about elapsed time.
> > 
> > Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Patch queued up for 3.19-rc1, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
