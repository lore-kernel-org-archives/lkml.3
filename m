Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845Ab3BITfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:35:45 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36451 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3BITfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:35:44 -0500
Date: Sat, 9 Feb 2013 11:35:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-kernel@vger.kernel.org, wimax@linuxwimax.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com
Subject: Re: [PATCH 20/25] wimax/i2400m: fix i2400m->wake_tx_skb handling
Message-ID: <20130209193539.GI2875@htj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-21-git-send-email-tj@kernel.org>
 <1357334395.18825.0.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357334395.18825.0.camel@dcbw.foobar.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 03:19:55PM -0600, Dan Williams wrote:
> On Fri, 2012-12-21 at 17:57 -0800, Tejun Heo wrote:
> > i2400m_net_wake_tx() sets ->wake_tx_skb with the given skb if
> > ->wake_tx_ws is not pending; however, i2400m_wake_tx_work() could have
> > just started execution and haven't fetched -><wake_tx_skb yet.  The
> > previous packet will be leaked.
> > 
> > Update ->wake_tx_skb handling.
> > 
> > * i2400m_net_wake_tx() now tests whether the previous ->wake_tx_skb
> >   has been consumed by ->wake_tx_ws instead of testing work_pending().
> > 
> > * i2400m_net_wake_stop() is simplified similarly.  It always puts
> >   ->wake_tx_skb if non-NULL.
> > 
> > * Spurious ->wake_tx_skb dereference outside critical section dropped
> >   from i2400m_wake_tx_work().
> > 
> > Only compile tested.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Acked-by: Dan Williams <dcbw@redhat.com>
> 
> No regressions in a quick connection check to Clear and browsing a bunch
> of pages.

Applied to wq/for-3.9-cleanups.

Thanks!

-- 
tejun
