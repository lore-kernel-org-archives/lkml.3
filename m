Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaIIU3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:29:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58050 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752610AbaIIU3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:29:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Tue, 09 Sep 2014 22:48:29 +0200
Message-ID: <5074996.Ni2JIb7nJr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140909152336.GB8890@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <20140909151655.GB4851@dhcp22.suse.cz> <20140909152336.GB8890@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2014 12:23:36 AM Tejun Heo wrote:
> On Tue, Sep 09, 2014 at 05:16:55PM +0200, Michal Hocko wrote:
> > But OOM killer doesn't kill kernel threads as they do not own any
> > memory. So the check should be safe, no?
> 
> Even for userland tasks, try_to_freeze() can currently be anywhere in
> the kernel.  The frequently used ones are few but there are some odd
> ones out, and, again, there's nothing enforcing any structure on
> try_to_freeze() usage.  The other thing is that we may do quite a bit
> during exiting including allocating memory.  Are those safe for system
> PM?  Rafael, what exactly are the rules for PM?  What shouldn't
> change?

We can't make any assumptions regarding the availability of any devices.
That is, whatever can end up in device access may potentially fail.

Rafael

