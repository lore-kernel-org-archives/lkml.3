Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaIODPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 23:15:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59639 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751700AbaIODPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 23:15:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Mon, 15 Sep 2014 05:34:36 +0200
Message-ID: <4489261.oHB60C5hao@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140915005657.GA11267@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <1527959.PBej7RR7ig@vostro.rjw.lan> <20140915005657.GA11267@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 15, 2014 09:56:57 AM Tejun Heo wrote:
> On Sun, Sep 14, 2014 at 06:43:31PM +0200, Rafael J. Wysocki wrote:
> > On Saturday, September 13, 2014 08:59:35 AM Tejun Heo wrote:
> > > Doesn't this mean that if PM freezing and OOM killing race each other,
> > > the system may hang?  Driver PM operation may try to allocate memory
> > > -> triggers OOM -> OOM killer selects an already frozen task ->
> > > nothing happens.  I wonder whether OOM killing and PM operations
> > > should be mutually exclusive at a higher level.  e.g. make OOM killing
> > > always override freezing but let hibernation abort operation before
> > > taking snapshot if OOM killing has happened since the beginning of the
> > > PM operation.
> > 
> > As Michal noted, we do oom_killer_disable() in freeze_processes(), so the
> > scenario above cannot actually happen to my eyes.  Or am I missing anything?
> 
> Ah, okay, that's better but it doesn't seem enough.  It does prevent
> new invocations of the oom killer but doesn't do anything if oom
> killing is already in progress.  If we do block out oom killing
> properly across PM freeze/thaw, it shoud be fine.

OK, so my assumption was that oom_killer_disable() would wait for the OOM
killing in progress to complete.  Alternatively, it can return an error code
if OOM killing is in progress and we can simply fail the freezing in that
case.

Rafael

