Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3FZH7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:59:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3FZH7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:59:23 -0400
Date: Wed, 26 Jun 2013 09:59:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Minchan Kim <minchan@kernel.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, anton@enomsg.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] vmpressure: implement strict mode
Message-ID: <20130626075921.GD28748@dhcp22.suse.cz>
References: <20130625175129.7c0d79e1@redhat.com>
 <20130626075051.GG29127@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626075051.GG29127@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-06-13 16:50:51, Minchan Kim wrote:
> On Tue, Jun 25, 2013 at 05:51:29PM -0400, Luiz Capitulino wrote:
> > Currently, applications are notified for the level they registered for
> > _plus_ higher levels.
> > 
> > This is a problem if the application wants to implement different
> > actions for different levels. For example, an application might want
> > to release 10% of its cache on level low, 50% on medium and 100% on
> > critical. To do this, the application has to register a different fd
> > for each event. However, fd low is always going to be notified and
> > and all fds are going to be notified on level critical.
> > 
> > Strict mode solves this problem by strictly notifiying the event
> > an fd has registered for. It's optional. By default we still notify
> > on higher levels.
> > 
> > Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> 
> Shouldn't we make this default?

The interface is not there for long but still, changing it is always
quite tricky. And the users who care can be modified really easily so I
would stick with the original default.

-- 
Michal Hocko
SUSE Labs
