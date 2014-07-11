Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaGKN1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:27:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbaGKN1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:27:36 -0400
Date: Fri, 11 Jul 2014 15:27:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [workqueue] WARNING: CPU: 0 PID: 76 at drivers/block/floppy.c:968
 schedule_bh()
In-Reply-To: <alpine.LNX.2.00.1407081656290.1655@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1407111526430.8779@pobox.suse.cz>
References: <20140708021149.GA12956@localhost> <20140708140430.GE4979@htj.dyndns.org> <20140708144632.GF4979@htj.dyndns.org> <alpine.LNX.2.00.1407081656290.1655@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Jiri Kosina wrote:

> > > Hmmm... this is schedule_bh() in floppy.c complaining that the work
> > > item is already pending.  The cond_resched() addition by b22ce2785d97
> > > doesn't change the semantics around work item execution although it
> > > could have exposed an existing problem in the floppy driver.  I'll
> > > look into how this could happen.
> > 
> > It doesn't reproduce here and nothing really stands out to me.  It
> > probably involves floppy_work requeueing itself and something else
> > getting executed inbetween which wouldn't have happend before, but I
> > can't figure out what that could be and either can I follow the
> > control flow the driver. :)
> >
> > 
> > Jiri, any ideas?
> 
> I will take a look. Could this be a bad bisect though due to this actually 
> being a race condition perhaps?

Fengguang, is it possible for you to confirm the bisection result (i.e. 
revert the patch and check)?

I am having hard time seeing how it could cause this (and I am not able to 
reproduce the problem myself).

Thanks,

-- 
Jiri Kosina
SUSE Labs
