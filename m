Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaDCPnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:43:15 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63403 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaDCPnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:43:11 -0400
Date: Thu, 3 Apr 2014 17:43:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/4] workqueues: Account unbound workqueue in a seperate
 list
Message-ID: <20140403154303.GG23338@localhost.localdomain>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
 <1395940862-31428-3-git-send-email-fweisbec@gmail.com>
 <20140330125751.GC8942@htj.dyndns.org>
 <20140403144826.GE23338@localhost.localdomain>
 <20140403150128.GD24119@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403150128.GD24119@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 11:01:28AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Apr 03, 2014 at 04:48:28PM +0200, Frederic Weisbecker wrote:
> > > Wouldn't the right thing to do would be factoring out
> > > apply_workqueue_attrs_locked()?  It's cleaner to block out addition of
> > > new workqueues while the masks are being updated anyway.
> > 
> > I'm not quite sure I get what you suggest. Do you mean have
> > apply_workqueue_attrs_locked() calling apply_workqueue_attrs() under
> > the lock on this patch?
> 
> Not sure it still matters but I was suggesting that creating
> apply_workqueue_attrs_locked() which requires the caller to handle
> locking and making apply_workqueue_attrs() a wrapper which grabs and
> releases lock around it, and using the former in locked iteration
> would work.  lol has this explanation made it any clearer or is it
> even worse now?  :)

I see, it gets a little better now :)

Maybe it still matters because I still need to iterate over unbound
workqueues to apply an update on "cpu_unbound_wqs_mask". And the list must remain
stable while I call apply_workqueue_attrs() on workqueues.

Anyway, we'll see how it looks like :)
