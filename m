Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3FZIUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:20:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48751 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZIUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:20:35 -0400
X-AuditID: 9c93016f-b7b0aae0000032af-7d-51caa4513142
Date: Wed, 26 Jun 2013 17:20:40 +0900
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, anton@enomsg.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] vmpressure: implement strict mode
Message-ID: <20130626082040.GI29127@bbox>
References: <20130625175129.7c0d79e1@redhat.com>
 <20130626075051.GG29127@bbox>
 <20130626075921.GD28748@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626075921.GD28748@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal,

On Wed, Jun 26, 2013 at 09:59:21AM +0200, Michal Hocko wrote:
> On Wed 26-06-13 16:50:51, Minchan Kim wrote:
> > On Tue, Jun 25, 2013 at 05:51:29PM -0400, Luiz Capitulino wrote:
> > > Currently, applications are notified for the level they registered for
> > > _plus_ higher levels.
> > > 
> > > This is a problem if the application wants to implement different
> > > actions for different levels. For example, an application might want
> > > to release 10% of its cache on level low, 50% on medium and 100% on
> > > critical. To do this, the application has to register a different fd
> > > for each event. However, fd low is always going to be notified and
> > > and all fds are going to be notified on level critical.
> > > 
> > > Strict mode solves this problem by strictly notifiying the event
> > > an fd has registered for. It's optional. By default we still notify
> > > on higher levels.
> > > 
> > > Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> > Acked-by: Minchan Kim <minchan@kernel.org>
> > 
> > Shouldn't we make this default?
> 
> The interface is not there for long but still, changing it is always
> quite tricky. And the users who care can be modified really easily so I
> would stick with the original default.

Yeb, I am not strong against to stick old at a moment but at least,
this patch makes more sense to me so I'd like to know why we didn't do it
from the beginning. Surely, Anton has a answer.

> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
