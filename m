Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3CEWek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:34:40 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:61310 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3CEWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:34:39 -0500
Date: Tue, 5 Mar 2013 14:34:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 16/31] workqueue: introduce workqueue_attrs
Message-ID: <20130305223434.GB1227@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-17-git-send-email-tj@kernel.org>
 <20130304183742.GI30413@htj.dyndns.org>
 <513671CF.5050705@gmail.com>
 <20130305223327.GA1227@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305223327.GA1227@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 02:33:27PM -0800, Tejun Heo wrote:
> Hello, Ryan.
> 
> On Wed, Mar 06, 2013 at 09:29:35AM +1100, Ryan Mallon wrote:
> > > @@ -148,6 +148,8 @@ struct worker_pool {
> > >  	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
> > >  	struct ida		worker_ida;	/* L: for worker IDs */
> > >  
> > > +	struct workqueue_attrs	*attrs;		/* I: worker attributes */
> > 
> > If attrs always exists, why not just embed the struct and avoid the
> > need to alloc/free it?
> 
> Because then it'll need a separate init paths for embedded ones.  If
> the field was in any way hot, I'd have embedded it but it isn't and
> it's just less code to share the alloc path.

Ooh, right, and that cpumask_t is going away and you can't statically
allocate cpumask_var_t, so it needs an allocation and error check from
it anyway.

-- 
tejun
