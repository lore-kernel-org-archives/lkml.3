Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaGHO5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:57:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbaGHO5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:57:01 -0400
Date: Tue, 8 Jul 2014 16:56:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [workqueue] WARNING: CPU: 0 PID: 76 at drivers/block/floppy.c:968
 schedule_bh()
In-Reply-To: <20140708144632.GF4979@htj.dyndns.org>
Message-ID: <alpine.LNX.2.00.1407081656290.1655@pobox.suse.cz>
References: <20140708021149.GA12956@localhost> <20140708140430.GE4979@htj.dyndns.org> <20140708144632.GF4979@htj.dyndns.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Tejun Heo wrote:

> > Hmmm... this is schedule_bh() in floppy.c complaining that the work
> > item is already pending.  The cond_resched() addition by b22ce2785d97
> > doesn't change the semantics around work item execution although it
> > could have exposed an existing problem in the floppy driver.  I'll
> > look into how this could happen.
> 
> It doesn't reproduce here and nothing really stands out to me.  It
> probably involves floppy_work requeueing itself and something else
> getting executed inbetween which wouldn't have happend before, but I
> can't figure out what that could be and either can I follow the
> control flow the driver. :)
>
> 
> Jiri, any ideas?

I will take a look. Could this be a bad bisect though due to this actually 
being a race condition perhaps?

-- 
Jiri Kosina
SUSE Labs
