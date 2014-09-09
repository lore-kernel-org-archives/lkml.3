Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaIIUeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:34:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49244 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751965AbaIIUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:34:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Tue, 09 Sep 2014 22:53:32 +0200
Message-ID: <2008100.1EF7gjK5Z6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140909164658.GB11748@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <20140909160625.GC4851@dhcp22.suse.cz> <20140909164658.GB11748@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2014 01:46:58 AM Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 09, 2014 at 06:06:25PM +0200, Michal Hocko wrote:
> > > Even for userland tasks, try_to_freeze() can currently be anywhere in
> > > the kernel.  The frequently used ones are few but there are some odd
> > 
> > I always thought that user space tasks can be in the fridge only on the
> > way out from the kernel (get_signal_to_deliver). I have quickly greped
> 
> It *can* be anywhere.  We used to have some deep in nfs.  They got
> removed later due to deadlocks but in theory they still can be
> anywhere.

Well, it would be good to determine the difference between theory and practice
in this particular respect, because if in practice it can't be anywhere,
we can just set an "every new instance of try_to_freeze() has to be documented"
rule (which may not be a bad idea anyway) and disallow people to break things.

Rafael

