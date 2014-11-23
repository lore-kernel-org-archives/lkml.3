Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbaKWFGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 00:06:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:64707 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaKWFGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 00:06:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,442,1413270000"; 
   d="scan'208";a="636638555"
Date: Sat, 22 Nov 2014 21:06:17 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [ftrace/x86/extable] WARNING: CPU: 0 PID: 1 at init/main.c:803
 do_one_initcall()
Message-ID: <20141123050617.GA9218@wfg-t540p.sh.intel.com>
References: <20141122184349.GB29361@wfg-t540p.sh.intel.com>
 <20141122141139.78927371@gandalf.local.home>
 <20141122195926.GA1707@wfg-t540p.sh.intel.com>
 <20141122165302.3df22b18@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141122165302.3df22b18@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 04:53:02PM -0500, Steven Rostedt wrote:
> On Sat, 22 Nov 2014 11:59:26 -0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> >
> > > Is it possible for your tests to see if a branch was rebased before
> > > posting bug reports to LKML? This gave me a scare that my new code had
> > > the same brain fart in it.
> > 
> > Sure and good idea! I'll implement it right now.
> > 
> 
> It should also make sure that the rebase does not include the offending
> commit before not sending out the email. A rebase alone may still have
> the bug.
> 
> And if you really want to be fancy, you can check to see if the code
> itself changed. The attached script takes two git releases (SHA1s,
> tags, etc) or one git release and uses HEAD, and finds where the two
> are different. Not just by commit id, but also by code. I use this
> because I'll modify a branch to add an acked-by and not change the code,
> but still want to know the last commit that I tested. It may not have
> the same commit id.

I definitely would like to be fancy. I think I'll not only check if
the branch has been rebased, but also test the rebased branch out to
make sure the problem is still there. I've been doing this check for
the build bisects. When doing so, it no longer matters how the rebased
branch differs from the original branch in source code level. For
example, even the simple rebase to a new RC base might make a problem
disappear.

Thanks,
Fengguang
