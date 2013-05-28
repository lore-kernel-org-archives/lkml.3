Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3E1BKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:10:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54386 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3E1BKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:10:23 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 27 May 2013 18:10:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-watchdog@vger.kernel.org, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com
Subject: Re: [PATCH v3] watchdog: Add hook for kicking in kdump path
Message-ID: <20130528011047.GA28597@roeck-us.net>
References: <1366233596-34681-1-git-send-email-dzickus@redhat.com>
 <87li8gaku0.fsf@xmission.com>
 <20130418130009.GH79013@redhat.com>
 <20130418134904.GC2767@roeck-us.net>
 <20130418135257.GL79013@redhat.com>
 <20130418145413.GA1980@roeck-us.net>
 <20130424144226.GI79013@redhat.com>
 <20130424152142.GA26864@roeck-us.net>
 <20130527191618.GD14258@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130527191618.GD14258@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 09:16:18PM +0200, Wim Van Sebroeck wrote:
>  Hi Guenter,
> 
> > > Hi Guenter,
> > > 
> > > Is there an easy way to determine which driver is loaded for each
> > > /dev/watchdogN device (from a script perspective).
> > > 
> > > Basically, I wanted to determine the module that needs to be included in
> > > the kdump initrd image.
> > > 
> > Sometimes. For example, the iTCO_wdt driver has an entry in /sys/devices, and
> > /sys/class/watchdog/watchdogX/device points to it. That is not always the case,
> > howewver. In my system, for example, the MEI watchdog is active, but there is
> > nothing I can find that would give me an indication that /dev/watchdog0 actually
> > points to the MEI watchdog driver.
> > 
> > Of course I might be missing something, and there might be some other means
> > to identify the driver from userspace. Would be great, actually, as I am having
> > the same problem.
> 
> Only when you set the .parent field in the watchdog_device data you will get the
> referal in the /sys/class/... tree. In iTCO_wdt.c you have the following code
> that does that: iTCO_wdt_watchdog_dev.parent = dev->dev.parent;
> 
> From the watchdog-kernel-api documentation:
> * parent: set this to the parent device (or NULL) before calling
>   watchdog_register_device.
> 
Hi Wim,

We live and learn ... thanks a lot for the hint!

Guenter
