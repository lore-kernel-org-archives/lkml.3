Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3F1ABt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:01:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46367 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3F1ABs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:01:48 -0400
X-AuditID: 9c930179-b7cafae000004567-41-51ccd26a24a5
Date: Fri, 28 Jun 2013 09:02:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, anton@enomsg.org,
        kmpark@infradead.org, hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130628000201.GB15637@bbox>
References: <20130626231712.4a7392a7@redhat.com>
 <20130627150231.2bc00e3efcd426c4beef894c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627150231.2bc00e3efcd426c4beef894c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Jun 27, 2013 at 03:02:31PM -0700, Andrew Morton wrote:
> On Wed, 26 Jun 2013 23:17:12 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
> > Currently, an eventfd is notified for the level it's registered for
> > _plus_ higher levels.
> > 
> > This is a problem if an application wants to implement different
> > actions for different levels. For example, an application might want
> > to release 10% of its cache on level low, 50% on medium and 100% on
> > critical. To do this, an application has to register a different
> > eventfd for each pressure level. However, fd low is always going to
> > be notified and and all fds are going to be notified on level critical.
> > 
> > Strict mode solves this problem by strictly notifiying an eventfd
> > for the pressure level it registered for. This new mode is optional,
> > by default we still notify eventfds on higher levels too.
> > 
> 
> It didn't take long for this simple interface to start getting ugly :(
> And having the fd operate in different modes is ugly.
> 
> Can we instead pass the level in the event payload?

You mean userland have to look the result of read(2) to confirm what
current level is and if it's no interest for us, we don't do any reaction.
If so, userland daemon would receive lots of events which are no interest.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
