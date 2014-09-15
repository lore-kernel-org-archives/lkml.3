Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaIOA5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 20:57:07 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38994 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaIOA5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 20:57:03 -0400
Date: Mon, 15 Sep 2014 09:56:57 +0900
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Michal Hocko <mhocko@suse.cz>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140915005657.GA11267@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140911163004.GN22042@dhcp22.suse.cz>
 <20140912235935.GB28183@mtj.dyndns.org>
 <1527959.PBej7RR7ig@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527959.PBej7RR7ig@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 06:43:31PM +0200, Rafael J. Wysocki wrote:
> On Saturday, September 13, 2014 08:59:35 AM Tejun Heo wrote:
> > Doesn't this mean that if PM freezing and OOM killing race each other,
> > the system may hang?  Driver PM operation may try to allocate memory
> > -> triggers OOM -> OOM killer selects an already frozen task ->
> > nothing happens.  I wonder whether OOM killing and PM operations
> > should be mutually exclusive at a higher level.  e.g. make OOM killing
> > always override freezing but let hibernation abort operation before
> > taking snapshot if OOM killing has happened since the beginning of the
> > PM operation.
> 
> As Michal noted, we do oom_killer_disable() in freeze_processes(), so the
> scenario above cannot actually happen to my eyes.  Or am I missing anything?

Ah, okay, that's better but it doesn't seem enough.  It does prevent
new invocations of the oom killer but doesn't do anything if oom
killing is already in progress.  If we do block out oom killing
properly across PM freeze/thaw, it shoud be fine.

Thanks.

-- 
tejun
