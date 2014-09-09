Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbaIIPRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:17:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905AbaIIPRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:17:01 -0400
Date: Tue, 9 Sep 2014 17:16:55 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140909151655.GB4851@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <3827451.ToKxd7Xb2J@vostro.rjw.lan>
 <20140908222253.GB3806@mtj.dyndns.org>
 <2588099.AI1YmNFQ25@vostro.rjw.lan>
 <20140908225012.GE3806@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908225012.GE3806@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-09-14 07:50:12, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 09, 2014 at 12:48:28AM +0200, Rafael J. Wysocki wrote:
> > Well, not exactly from anywhere.  Just from where try_to_freeze() is called
> > I suppose?
> 
> Yeap, anywhere try_to_freeze() may be called.
> 
> > Which means that if this is a user space task, it won't to a lot before dying,
> > will it?
> 
> Userland tasks aren't likely to a lot of damages before dying but then
> again there's no guarantee.  As it currently stands, try_to_freeze()
> can be anywhere.

But OOM killer doesn't kill kernel threads as they do not own any
memory. So the check should be safe, no?
-- 
Michal Hocko
SUSE Labs
