Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbaEITz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:55:26 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:42097 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbaEITzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:55:25 -0400
Date: Fri, 9 May 2014 15:55:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.16 2/2] percpu-refcount: implement
 percpu_ref_tryget()
Message-ID: <20140509195522.GF4486@htj.dyndns.org>
References: <20140507155511.GB26540@htj.dyndns.org>
 <20140507155647.GC26540@htj.dyndns.org>
 <20140507155810.GD26540@htj.dyndns.org>
 <20140509194020.GB2276@kmo>
 <20140509194140.GC4486@htj.dyndns.org>
 <20140509195109.GC2276@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509195109.GC2276@kmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 09, 2014 at 12:51:09PM -0700, Kent Overstreet wrote:
> Well not so much deprecated as "bad, avoid" - IMO using tryget() almost always
> (I haven't seen a convincing counterexample) means you screwed up your
> refcounting somewhere, if you need to take a ref on something whatever made that
> object visible to you should have its own ref.
> 
> (I think we had this debate, but that was awhile ago...)

Oh sure, tryget can definitely be misunderstood but RCU protected
iteration is one valid use case.

	rcu_read_lock();
	locate the object of interest;
	tryget[_live]() depending on the use case;
	rcu_read_unlock();

	access the object.

It's not different from why we use atomic_inc_not_zero() in some
places.  The only difference is that percpu_ref distinguishes live
vs. dying states.  It's true that this can be used in pretty stupid
ways but I think the comments are pretty clear on that.  Do you think
we need more warning there?

Thanks.

-- 
tejun
