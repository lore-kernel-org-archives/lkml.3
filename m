Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaINQX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:23:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51920 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752668AbaINQX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:23:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Sun, 14 Sep 2014 18:43:31 +0200
Message-ID: <1527959.PBej7RR7ig@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140912235935.GB28183@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <20140911163004.GN22042@dhcp22.suse.cz> <20140912235935.GB28183@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 13, 2014 08:59:35 AM Tejun Heo wrote:
> On Thu, Sep 11, 2014 at 06:30:04PM +0200, Michal Hocko wrote:
> > > I am wondering if the folllowing check makes any sense with regarding
> > > to rule out PM freeze:
> > > 
> > >         if ((!pm_nosig_freezing && !pm_freezing) &&
> > >             cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
> > >                 return true;
> 
> Doesn't this mean that if PM freezing and OOM killing race each other,
> the system may hang?  Driver PM operation may try to allocate memory
> -> triggers OOM -> OOM killer selects an already frozen task ->
> nothing happens.  I wonder whether OOM killing and PM operations
> should be mutually exclusive at a higher level.  e.g. make OOM killing
> always override freezing but let hibernation abort operation before
> taking snapshot if OOM killing has happened since the beginning of the
> PM operation.

As Michal noted, we do oom_killer_disable() in freeze_processes(), so the
scenario above cannot actually happen to my eyes.  Or am I missing anything?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
