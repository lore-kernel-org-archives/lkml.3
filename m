Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbaCEBB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:01:56 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41582 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaCEBBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:01:55 -0500
Date: Tue, 4 Mar 2014 17:01:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question on vhost_has_feature()
Message-ID: <20140305010151.GA3334@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140303194422.GA17107@linux.vnet.ibm.com>
 <20140304075642.GA8031@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304075642.GA8031@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030501-3532-0000-0000-00000008E5A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:56:42AM +0200, Michael S. Tsirkin wrote:
> On Mon, Mar 03, 2014 at 11:44:23AM -0800, Paul E. McKenney wrote:
> > Hello, Michael,
> > 
> > Just curious about the purpose of the rcu_dereference_index_check() in
> > vhost_has_feature().  I don't see how it fits in.  The closest thing
> > I see if the use in handle_rx(), where it selects vq->log or NULL.  But
> > in that case, I would expect the usual RCU usage pattern to wrap an
> > rcu_dereference() around the vq->log.
> > 
> > Enlightenment?
> > 
> > 							Thanx, Paul
> 
> Hi Paul,
> 
> Yes, it's weird.  As you say the use is in handle_rx.
> The way it's supposed to work is that readers take vq mutex, and
> writers change the value and then take and release
> vq mutex.
> We did it like this because there are thinkably multiple vqs.
> 
> I tried to document it in vhost.h :
>         /* Readers use RCU to access memory table pointer
>          * log base pointer and features.
>          * Writers use mutex below.*/
> 
> If this is a problem, it's possible to restructure the code to avoid
> this pattern for vhost_has_feature, pls let me know.

I am not yet sure whether or not it is a problem, it just looked a bit
strange.  ;-)

							Thanx, Paul

> Thanks a lot for paying attention!
> 
> 
> -- 
> MST
> 

