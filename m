Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3G3OOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:14:24 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:36440 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3G3OOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:14:22 -0400
Date: Tue, 30 Jul 2013 10:14:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch]workqueue: copy attr with all fields.
Message-ID: <20130730141419.GG12016@htj.dyndns.org>
References: <20130729062412.GA6448@kernel.org>
 <20130729111401.GA20951@mtj.dyndns.org>
 <20130729125259.GA9306@kernel.org>
 <20130729153523.GA22605@mtj.dyndns.org>
 <20130730054955.GA5225@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730054955.GA5225@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Tue, Jul 30, 2013 at 01:49:55PM +0800, Shaohua Li wrote:
> > Note that copy_workqueue_attrs() is also used while creating worker
> > pools and this change would mean that there will be worker pools with
> > no_numa attribute assigned basically randomly depending on which wq
> > created the pool for the first time which should be fine AFAICS but
> > isn't very nice.  Given that there's only single place where a pool's
> > attrs is set, maybe it'd be best to clear no_numa right after copy and
> > explain what's going on there?
> 
> alloc_workqueue_attrs() always zero the new allocated attr.

Hmmm?  Yeah, sure, that's how it currently is always zero for all
pools.  If you change the copy function, it'll now be set to whatever
the input value was when a pool was created, which shouldn't break
anything but is a bit confusing as no_numa doesn't have anything to do
with pools directly.  Just in case, I'm talking about
copy_workqueue_attrs() call in get_unbound_pool().

Thanks.

-- 
tejun
