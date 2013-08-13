Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3HMXD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:03:58 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:64135 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3HMXD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:03:56 -0400
Date: Tue, 13 Aug 2013 19:03:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
Message-ID: <20130813230352.GH28996@mtj.dyndns.org>
References: <52099187.80301@tilera.com>
 <20130813123512.3d6865d8bf4689c05d44738c@linux-foundation.org>
 <20130813201958.GA28996@mtj.dyndns.org>
 <20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org>
 <20130813210719.GB28996@mtj.dyndns.org>
 <20130813141621.3f1c3415901d4236942ee736@linux-foundation.org>
 <20130813220700.GC28996@mtj.dyndns.org>
 <20130813151805.b1177b60cba5b127b2aa6aee@linux-foundation.org>
 <20130813223304.GF28996@mtj.dyndns.org>
 <20130813154740.5daa053df87dd0358bbbab35@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813154740.5daa053df87dd0358bbbab35@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Tue, Aug 13, 2013 at 03:47:40PM -0700, Andrew Morton wrote:
> > Well, I don't buy that either.  Callback based interface has its
> > issues.
> 
> No it hasn't.  It's a common and simple technique which we all understand.

It sure has its uses but it has receded some of its former use cases
to better constructs which are easier to use and maintain.  I'm not
saying it's black and white here as the thing is callback based anyway
but was trying to point out general disadvantages of callback based
interface.  If you're saying callback based interface isn't clunkier
compared to constructs which can be embedded in the caller side, this
discussion probably won't be very fruitful.

> It's a relatively small improvement in the lru_add_drain_all() case. 
> Other callsites can gain improvements as well.

Well, if we're talking about minute performance differences, for
non-huge configurations, it'll actually be a small performance
degradation as there will be more instructions and the control will be
jumping back and forth.

> It results in superior runtime code.  At this and potentially other
> callsites.

It's actually inferior in majority of cases.

> It does buy us things, as I've repeatedly described.  You keep on
> saying things which demonstrably aren't so.  I think I'll give up now.

I just don't think it's something clear cut and it doesn't even matter
for the problem at hand.  Let's please talk about how to solve the
actual problem.

Thanks.

-- 
tejun
