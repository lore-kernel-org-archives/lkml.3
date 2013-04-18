Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967416Ab3DROx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:53:57 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58673 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967009Ab3DROxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:53:55 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 18 Apr 2013 07:54:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Don Zickus <dzickus@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-watchdog@vger.kernel.org, kexec@lists.infradead.org,
        wim@iguana.be, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com
Subject: Re: [PATCH v3] watchdog: Add hook for kicking in kdump path
Message-ID: <20130418145413.GA1980@roeck-us.net>
References: <1366233596-34681-1-git-send-email-dzickus@redhat.com>
 <87li8gaku0.fsf@xmission.com>
 <20130418130009.GH79013@redhat.com>
 <20130418134904.GC2767@roeck-us.net>
 <20130418135257.GL79013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418135257.GL79013@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 09:52:57AM -0400, Don Zickus wrote:
> On Thu, Apr 18, 2013 at 06:49:04AM -0700, Guenter Roeck wrote:
> > On Thu, Apr 18, 2013 at 09:00:09AM -0400, Don Zickus wrote:
> > > On Wed, Apr 17, 2013 at 02:49:59PM -0700, Eric W. Biederman wrote:
> > > > Don Zickus <dzickus@redhat.com> writes:
> > > > 
> > > > > A common problem with kdump is that during the boot up of the
> > > > > second kernel, the hardware watchdog times out and reboots the
> > > > > machine before a vmcore can be captured.
> > > > >
> > > > > Instead of tellling customers to disable their hardware watchdog
> > > > > timers, I hacked up a hook to put in the kdump path that provides
> > > > > one last kick before jumping into the second kernel.
> > > > >
> > > > > The assumption is the watchdog timeout is at least 10-30 seconds
> > > > > long, enough to get the second kernel to userspace to kick the watchdog
> > > > > again, if needed.
> > > > 
> > > > Why not double the watchdog timeout? and/or pet the watchdog a little
> > > > more frequently.
> > > 
> > > I am not sure if the watchdog timeouts can be doubled.  I think Guenter
> > > was saying some have a max of a couple seconds?? Petting a little more
> > > frequently might be an option.  Guenter can that be done with a softdog
> > > option?
> > > 
> > Most watchdog driver permit at least a minute. Some are more limited.
> > Worst I have seen is the BookE watchdog timer (non-Freescale version)
> > which has a maximum of three seconds. But that is broken anyway.
> > 
> > Most hardware watchdogs implement a softdog on top of the hardware watchdog
> > if the hardware needs to be pinged faster than every 60 seconds.
> > 
> > So, yes, for the most common case you should actually be able to live with a,
> > say, 30-60 second timeout which is pinged at least every 5-10 seconds. I thought
> > that somehow did not work in your case. Maybe a misunderstanding ?
> 
> No, that will probably work.  It is my misunderstanding.  Is there a
> common way to check the timeout length and the ping frequency?
> 
Usually it is configured in /etc/watchdog.conf if the watchdog package
is installed. The standard ping interval is "interval", the timeout is
"watchdog-timeout". See "man watchdog.conf" for details.

Minimum and maximum values for a given watchdog driver are not exported
to user space, so you would have to look into the driver sources to find
out what they are.

Guenter
