Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3A1TuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:50:00 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:39894 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A1Tt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:49:57 -0500
Date: Mon, 28 Jan 2013 11:49:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 10/25] kprobes: fix wait_for_kprobe_optimizer()
Message-ID: <20130128194949.GJ22465@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-11-git-send-email-tj@kernel.org>
 <50D922C9.3020706@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D922C9.3020706@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 12:51:37PM +0900, Masami Hiramatsu wrote:
> (2012/12/22 10:57), Tejun Heo wrote:
> > wait_for_kprobe_optimizer() seems largely broken.  It uses
> > optimizer_comp which is never re-initialized, so
> > wait_for_kprobe_optimizer() will never wait for anything once
> > kprobe_optimizer() finishes all pending jobs for the first time.
> 
> Thank you for fixing that!
> I must misunderstand that the DECLARE_COMPLETION() macro.
> 
> > Also, aside from completion, delayed_work_pending() is %false once
> > kprobe_optimizer() starts execution and wait_for_kprobe_optimizer()
> > won't wait for it.
> >
> > Reimplement it so that it flushes optimizing_work until
> > [un]optimizing_lists are empty.  Note that this also makes
> > optimizing_work execute immediately if someone's waiting for it, which
> > is the nicer behavior.
> 
> I think your enhancement is reasonable and GOOD for me.
> 
> Thanks again!
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Can I take it through workqueue branch w/ other patches?

Thanks!

-- 
tejun
