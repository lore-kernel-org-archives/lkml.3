Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaLDO53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:57:29 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:63725 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaLDO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:57:27 -0500
Date: Thu, 4 Dec 2014 09:57:22 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: NeilBrown <neilb@suse.de>, Jan Kara <jack@suse.cz>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141204145722.GC15219@htj.dyndns.org>
References: <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
 <20141118152754.60b0c75e@notabene.brown>
 <20141202204304.GR10918@htj.dyndns.org>
 <20141203114011.5d02dc43@notabene.brown>
 <20141203172010.GC5013@htj.dyndns.org>
 <20141203180241.GD5013@htj.dyndns.org>
 <547FB27E.5030904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547FB27E.5030904@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 09:01:50AM +0800, Lai Jiangshan wrote:
> > +			if (need_to_create_worker(pool)) {
> > +				spin_lock(&wq_mayday_lock);
> > +				list_move_tail(&pwq->mayday_node, &wq->maydays);
> 
> how about the pwq is empty now? and ...

It will be taken off list the next round.  It's silly to scan the list
again here.  The only thing that'd do is adding more code and adding
an extra scan when the pwq actually needs to be requeued.

> > +				spin_unlock(&wq_mayday_lock);
> > +			}
> > +		}
> >  
> >  		/*
> >  		 * Put the reference grabbed by send_mayday().  @pool won't
> 
> and the pwq is scheduled free here> 

Added get_pwq() before list_move_tail() as Dongsu suggested.

Thanks.

-- 
tejun
