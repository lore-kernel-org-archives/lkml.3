Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbbAUOQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:16:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbbAUOQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:16:01 -0500
Date: Wed, 21 Jan 2015 09:15:52 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        uobergfe@redhat.com
Subject: Re: [PATCH 0/9] watchdog: internally split softlockup and hardlockup
Message-ID: <20150121141552.GB116159@redhat.com>
References: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:20:15AM -0500, Don Zickus wrote:
> The hardlockup and softockup had always been tied together.  Due to the request
> of KVM folks, they had a need to have one enabled but not the other.
> Internally rework the code to split things apart more cleanly.
> 
> There is a bunch of churn here, but the end result should be code that should
> be easier to maintain and fix without knowing the internals of what is going
> on.
> 
> Tested by Uli and myself.

Hi Andrew,

Poking again.  What can I do to move this along?  Should I repost?

Cheers,
Don

> 
> Ulrich Obergfell (9):
>   watchdog: new definitions and variables, initialization
>   watchdog: introduce the proc_watchdog_update() function
>   watchdog: move definition of 'watchdog_proc_mutex' outside of
>     proc_dowatchdog()
>   watchdog: introduce the proc_watchdog_common() function
>   watchdog: introduce separate handlers for parameters in
>     /proc/sys/kernel
>   watchdog: implement error handling for failure to set up hardware
>     perf events
>   watchdog: enable the new user interface of the watchdog mechanism
>   watchdog: clean up some function names and arguments
>   watchdog: introduce the hardlockup_detector_disable() function
> 
>  arch/x86/kernel/kvm.c |    2 +-
>  include/linux/nmi.h   |   21 ++--
>  kernel/sysctl.c       |   35 +++++--
>  kernel/watchdog.c     |  277 ++++++++++++++++++++++++++++++++++++-------------
>  4 files changed, 240 insertions(+), 95 deletions(-)
> 
