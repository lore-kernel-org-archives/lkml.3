Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaIIPXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:23:43 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60521 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaIIPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:23:41 -0400
Date: Wed, 10 Sep 2014 00:23:36 +0900
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140909152336.GB8890@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <3827451.ToKxd7Xb2J@vostro.rjw.lan>
 <20140908222253.GB3806@mtj.dyndns.org>
 <2588099.AI1YmNFQ25@vostro.rjw.lan>
 <20140908225012.GE3806@mtj.dyndns.org>
 <20140909151655.GB4851@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909151655.GB4851@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:16:55PM +0200, Michal Hocko wrote:
> But OOM killer doesn't kill kernel threads as they do not own any
> memory. So the check should be safe, no?

Even for userland tasks, try_to_freeze() can currently be anywhere in
the kernel.  The frequently used ones are few but there are some odd
ones out, and, again, there's nothing enforcing any structure on
try_to_freeze() usage.  The other thing is that we may do quite a bit
during exiting including allocating memory.  Are those safe for system
PM?  Rafael, what exactly are the rules for PM?  What shouldn't
change?

Thanks.

-- 
tejun
