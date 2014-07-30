Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaG3RHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:07:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbaG3RHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:07:32 -0400
Date: Wed, 30 Jul 2014 13:07:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, Ulrich Obergfell <uobergfe@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
Message-ID: <20140730170719.GF7959@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com>
 <1406196811-5384-3-git-send-email-drjones@redhat.com>
 <615371508.17867577.1406277175913.JavaMail.zimbra@redhat.com>
 <20140725112510.GA3456@hawk.usersys.redhat.com>
 <20140730134342.GA7959@redhat.com>
 <53D8FE46.2000100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D8FE46.2000100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 04:16:38PM +0200, Paolo Bonzini wrote:
> Il 30/07/2014 15:43, Don Zickus ha scritto:
> >> > Nice catch. Looks like this will need a v2. Paolo, do we have a
> >> > consensus on the proc echoing? Or should that be revisited in the v2 as
> >> > well?
> > As discussed privately, how about something like this to handle that case:
> > (applied on top of these patches)
> 
> Don, what do you think about proc?
> 
> My opinion is still what I mentioned earlier in the thread, i.e. that if
> the file says "1", writing "0" and then "1" should not constitute a
> change WRT to the initial state.
> 

I can agree.  The problem is there are two things this proc value
controls, softlockup and hardlockup.  I have always tried to keep the both
disabled or enabled together.

This patchset tries to separate them for an edge case.  Hence the proc
value becomes slightly confusing.

I don't know the right way to solve this without introducing more proc
values.

We have /proc/sys/kernel/nmi_watchdog and /proc/sys/kernel/watchdog which
point to the same internal variable.  Do I separate them and have
'nmi_watchdog' just mean hardlockup and 'watchdog' mean softlockup?  Then
we can be clear on what the output is.  Or does 'watchdog' represent a
superset of 'nmi_watchdog' && softlockup?

That is where the confusion lies.

Cheers,
Don

