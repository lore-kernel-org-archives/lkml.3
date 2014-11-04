Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaKDOWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:22:46 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:43949 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKDOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:22:45 -0500
Date: Tue, 4 Nov 2014 09:22:40 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141104142240.GD14459@htj.dyndns.org>
References: <20141029172608.39119c80@notabene.brown>
 <20141029143210.GA25226@htj.dyndns.org>
 <20141030101932.2241daa7@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030101932.2241daa7@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

Sorry about the delay.

On Thu, Oct 30, 2014 at 10:19:32AM +1100, NeilBrown wrote:
> >                           Given that workder depletion is pool-wide
> > event, maybe it'd make sense to trigger rescuers immediately while
> > workers are in short supply?  e.g. while there's a manager stuck in
> > maybe_create_worker() with the mayday timer already triggered?
> 
> So what if I change "need_more_worker" to "need_to_create_worker" ?
> Then it will stop as soon as there in an idle worker thread.
> That is the condition that keeps maybe_create_worker() looping.
> ??

Yeah, that'd be a better condition and can work out.  Can you please
write up a patch to do that and do some synthetic tests excercising
the code path?  Also please cc Lai Jiangshan <laijs@cn.fujitsu.com>
when posting the patch.

Thanks.

-- 
tejun
