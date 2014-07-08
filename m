Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaGHOqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:46:37 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36083 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGHOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:46:35 -0400
Date: Tue, 8 Jul 2014 10:46:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [workqueue] WARNING: CPU: 0 PID: 76 at
 drivers/block/floppy.c:968 schedule_bh()
Message-ID: <20140708144632.GF4979@htj.dyndns.org>
References: <20140708021149.GA12956@localhost>
 <20140708140430.GE4979@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708140430.GE4979@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:04:30AM -0400, Tejun Heo wrote:
...
> Hmmm... this is schedule_bh() in floppy.c complaining that the work
> item is already pending.  The cond_resched() addition by b22ce2785d97
> doesn't change the semantics around work item execution although it
> could have exposed an existing problem in the floppy driver.  I'll
> look into how this could happen.

It doesn't reproduce here and nothing really stands out to me.  It
probably involves floppy_work requeueing itself and something else
getting executed inbetween which wouldn't have happend before, but I
can't figure out what that could be and either can I follow the
control flow the driver. :)

Jiri, any ideas?

Thanks.

-- 
tejun
