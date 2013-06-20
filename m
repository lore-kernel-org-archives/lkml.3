Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582Ab3FTC35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:29:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42192 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935506Ab3FTC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:29:55 -0400
Date: Wed, 19 Jun 2013 19:28:37 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, icycoder@gmail.com
Subject: Re: [PATCH 1/2] perf tools: fix a typo of a Power7 event name
Message-ID: <20130620022837.GA20609@us.ibm.com>
References: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1371691282.21846.1.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371691282.21846.1.camel@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062002-5518-0000-0000-00000FBDA427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| On Wed, 2013-06-19 at 17:15 +0800, Runzhen Wang wrote:
| > In the Power7 PMU guide:
| > https://www.power.org/documentation/commonly-used-metrics-for-performance-analysis/
| > PM_BRU_MPRED is referred to as PM_BR_MPRED.
| > 
| > This patch fix the typo by changing the name of the event in kernel and
| > documentation accordingly.
| > 
| > Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
| > ---
| >  .../testing/sysfs-bus-event_source-devices-events  |    2 +-
| >  arch/powerpc/perf/power7-pmu.c                     |   12 ++++++------
| >  2 files changed, 7 insertions(+), 7 deletions(-)
| > 
| > diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
| > index 8b25ffb..3c1cc24 100644
| > --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
| > +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
| > @@ -29,7 +29,7 @@ Description:	Generic performance monitoring events
| >  
| >  What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
| >  		/sys/devices/cpu/events/PM_BRU_FIN
| > -		/sys/devices/cpu/events/PM_BRU_MPRED
| > +		/sys/devices/cpu/events/PM_BR_MPRED
| 
| So you're changing the ABI.
| 
| I think that's probably OK, but you at least need to mention _why_ you
| think it's OK.

Some of the reasons I think its ok to change:

- It is relatively new interface, specific to the Power7 platform.

- No tools that we know of actually use this interface at this point (none
  are listed near the interface).

- Users of this interface (eg oprofile users migrating to perf) would be
  more used to the "PM_BR_MPRED" rather than "PM_BRU_MPRED".

- These are in the ABI/testing at this point rather than ABI/stable, so
  hoping we have some wiggle room.

But of course this is not a "grave error" or "security hole" which are
the justifications listed in the Documentation/ABI/README.  If these
are not good enough reasons, we can leave the misnomer around and
create another file in sysfs with the correct name PM_BR_MPRED.

Sukadev

