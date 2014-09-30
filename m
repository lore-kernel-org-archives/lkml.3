Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaI3QH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:07:59 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:38420
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaI3QH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:07:57 -0400
Date: Tue, 30 Sep 2014 18:07:55 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Mateusz Guzik <mguzik@redhat.com>, David Howells <dhowells@redhat.com>,
        "Pavel Emelyanov (xemul@parallels.com)" <xemul@parallels.com>
Subject: Re: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according
 to ns
Message-ID: <20140930160755.GB6838@mail.hallyn.com>
References: <1411552827-31056-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1411552827-31056-3-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5871495633F38949900D2BF2DC04883E5C7377@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140929140010.GA20069@mail.hallyn.com>
 <5871495633F38949900D2BF2DC04883E5CF0D5@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140930160549.GA6838@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930160549.GA6838@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Chen, Hanxiao (chenhanxiao@cn.fujitsu.com):
> > Hi,
> > 
> > > -----Original Message-----
> > > From: Serge E. Hallyn [mailto:serge@hallyn.com]
> > > Sent: Monday, September 29, 2014 10:00 PM
> > > Subject: Re: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according to
> > > ns
> > [snip]
> > > > >
> > > > > This patch adds four fields: NStgid, NSpid, NSpgid and NSsid:
> > > > > a) In init_pid_ns, nothing changed;
> > > > >
> > > > > b) In one pidns, will tell the pid inside containers:
> > > > > NStgid:	21776   5       1
> > > > > NSpid:  21776   5       1
> > > > > NSpgid:	21776   5       1
> > > > > NSsid:  21729   1       0
> > > > > ** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.
> > > > >
> > > > > c) If pidns is nested, it depends on which pidns are you in.
> > > > > NStgid: 5       1
> > > > > NSpid:  5       1
> > > > > NSpgid: 5       1
> > > > > NSsid:  1       0
> > > > > ** Views from level 1
> > > > >
> > > >
> > > > This patch is simple, useful and safe.
> > > > But currently there is not any feedbacks.
> > > >
> > > > Any comments or ideas?
> > > 
> > > Thanks, Chen.  The code looks fine.  My concern is that you are
> > > exposing information which cannot be checkpointed and restarted.
> > > In particular, if I'm inside a nested container, so I'm in pidns
> > > level 3, then my own NSpid info, when I read it, will show the
> > > pids at parent namespaces.  If I'm restarted at the third pidns
> > > level, only the one pid can be restored.
> > 
> > If you're in level 3, read your own proc, only level 3's NSpid info
> > will be shown. No parent namesapces info could be seen.
> 
> D'oh!  Sorry, I see, you're starting at ns->level.  And ns is the ns
> of the proc mount, not the caller.  that looks good.
> 
> So
> 
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Also

Tested-by: Serge Hallyn <serge.hallyn@canonical.com>

as I've tested this between a few containers.
