Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160Ab3DJRRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:17:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62684 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965106Ab3DJRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:17:16 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 10 Apr 2013 10:17:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Teigland <teigland@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-watchdog@vger.kernel.org, kexec@lists.infradead.org,
        wim@iguana.be, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com
Subject: Re: [RFC PATCH] watchdog: Add hook for kicking in kdump path
Message-ID: <20130410171722.GC19533@roeck-us.net>
References: <1365192994-94850-1-git-send-email-dzickus@redhat.com>
 <516259D2.7000805@redhat.com>
 <20130408124858.GC79013@redhat.com>
 <20130408151509.GA20919@roeck-us.net>
 <20130409144431.GL79013@redhat.com>
 <20130409145228.GA1111@roeck-us.net>
 <20130409151423.GM79013@redhat.com>
 <20130409160757.GA27050@roeck-us.net>
 <20130410134039.GV79013@redhat.com>
 <20130410164914.GA18946@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410164914.GA18946@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:49:14PM -0400, David Teigland wrote:
> On Wed, Apr 10, 2013 at 09:40:39AM -0400, Don Zickus wrote:
> > However, we still have the problem that if the machine panics and we want
> > to jump into the kdump kernel, we need to 'kick' the watchdog one more
> > time.  This provides us a sane sync point for determining how long we have
> > to load the watchdog driver in the second kernel before the hardware
> > reboots us.  Otherwise the reboots are pretty random and nothing is
> > guaranteed.
> 
> Some time ago I submitted this patch
> http://www.spinics.net/lists/linux-watchdog/msg01477.html
> 
> to get rid of the one "extraneous" ping that was causing me trouble.
> I'd still like to see merged, but haven't had time to follow up.
> 
The use case makes sense to me, so it gets my Ack. Did Wim ever comment on it ?

Thanks,
Guenter

> I have a use case where I need to guarantee that the watchdog
> will *not* be pinged unless my userland daemon does the ping.
> If my daemon is killed, the close() generates a ping that I
> don't intend.  This kdump ping looks like it would be another
> instance that I'd need to suppress.  Perhaps by renaming my flag
> WDOG_NO_EXTRA_PING and checking it both in release and in
> kick_for_kdump?
> 
> (My daemon associates watchdog pings with shared storage heartbeats.
> Based on the heartbeats, hosts in a cluster can calculate when an
> unresponsive host last pinged its watchdog, and can be fairly
> certain that the "dead" host has been reset by its watchdog 60
> seconds later.  This is used as an alternative to i/o fencing
> where we're protecting data on shared storage from corruption
> after host failures.  If there are uncontrolled watchdog pings,
> then hosts don't know when a dead host might have last pinged
> its watchdog, since it is no longer based on the last timestamp
> it wrote to shared storage.)
> 
> Dave
> 
