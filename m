Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936009Ab3DIOom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761532Ab3DIOol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:44:41 -0400
Date: Tue, 9 Apr 2013 10:44:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dave Young <dyoung@redhat.com>, linux-watchdog@vger.kernel.org,
        kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com
Subject: Re: [RFC PATCH] watchdog: Add hook for kicking in kdump path
Message-ID: <20130409144431.GL79013@redhat.com>
References: <1365192994-94850-1-git-send-email-dzickus@redhat.com>
 <516259D2.7000805@redhat.com>
 <20130408124858.GC79013@redhat.com>
 <20130408151509.GA20919@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408151509.GA20919@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 08:15:09AM -0700, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 08:48:58AM -0400, Don Zickus wrote:
> > On Mon, Apr 08, 2013 at 01:46:58PM +0800, Dave Young wrote:
> > > On 04/06/2013 04:16 AM, Don Zickus wrote:
> > > > A common problem with kdump is that during the boot up of the
> > > > second kernel, the hardware watchdog times out and reboots the
> > > > machine before a vmcore can be captured.
> > > > 
> > > > Instead of tellling customers to disable their hardware watchdog
> > > > timers, I hacked up a hook to put in the kdump path that provides
> > > > one last kick before jumping into the second kernel.
> > > > 
> > > > The assumption is the watchdog timeout is at least 10-30 seconds
> > > > long, enough to get the second kernel to userspace to kick the watchdog
> > > > again, if needed.
> > > 
> > > For kdump kernel some devices need to reset, this might increase the
> > > boot time, it's not so reliable for the 10-30s for us to kicking the
> > > watchdog.
> > > 
> > > Could we have another option to disable/stop the watchdog while panic
> > > happens? Ie. add a kernel cmdline panic_stop_wd=<0|1> for 1st kernel, if
> > > it's set to 1, then just stop the watchdog or we can kick the watchdog
> > > like what you do in this patch. Of course stopping watchdog should be
> > > lockless as well..
> > 
> > Hmm, I can look into that.  But I am not sure all watchdogs have the
> > ability to stop once started.  I was also worried about the case where
> 
> Correct.
> 
> > kdump hangs for some reason.  Having the watchdog there to 'reboot' would
> > be a nice safety net.
> > 
> Absolutely agree. After all, the reason for the kdump is most likely that
> something went really wrong, meaning there is some likelyhood for the hang
> to occur. Turning off the watchdog in this condition does not seem to be
> a good idea.
> 
> > Perhaps adjusting the watchdog 'timeout' to something like 3 minutes would
> > be easier?
> > 
> Not all watchdogs support such large timeouts, unfortunately. Maybe it would
> make sense to implement infrastructure support for a softdog on top of the
> hardware watchdog. Several drivers implement that outside the infrastructure
> already.

Hi Guenter,

I am not familar with a softdog.  Can you give me an example of how it
works?

Cheers,
Don
