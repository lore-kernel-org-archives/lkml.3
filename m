Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaAOPMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:12:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaAOPMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:12:19 -0500
Date: Wed, 15 Jan 2014 16:12:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Victor Porton <porton@narod.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: Notifying on empty cgroup
Message-ID: <20140115151218.GO8782@dhcp22.suse.cz>
References: <135711389759165@web22h.yandex.ru>
 <20140115135930.GK8782@dhcp22.suse.cz>
 <409331389795100@web18j.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <409331389795100@web18j.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-01-14 16:11:40, Victor Porton wrote:
> 15.01.2014, 15:59, "Michal Hocko" <mhocko@suse.cz>:
> > [CCing cgroups mailing list]
> > On Wed 15-01-14 06:12:45, Victor Porton wrote:
> >
> >>  I want to write software which needs to receive a signal when the cgroup
> >>  created by it becomes empty. (After this the empty cgroup should be deleted
> >>  just not to clutter the memory.)
> >>
> >>  If the kernel does not support such notifications, it should be improved.
> >>  This functionality is crucial for some kinds of software.
> >>
> >>  There is /sys/fs/cgroup/systemd/release_agent but I don't understand how to
> >>  use it. I don't understand why we would need it at all.
> >
> > "1.4 What does notify_on_release do ?" in
> > Documentation/cgroups/cgroups.txt the kernel source doesn't help?
> 
> I've read it. I understand what it does. I don't understand how to use
> it in practice nor

You want to clean up your memcg without any tasks so the script might do
something like:
---
#!/bin/sh

CGROUP="$1"
CGROUP_MNT=`mount | grep cgroup | awk '{print $3}'`

rmdir "$CGROUP_MNT/$CGROUP"
---

> why it is done this way.

I find the interface rather awkward as well but that is a question for
those who have implement it.

The interface will change in the future (sorry I do not have any link to
discussion about the change handy).

> >>  Starting a binary on emptying a cgroup with the purpose to notify an other
> >>  binary looks like a big overkill.
> >
> > the binary can do rmdir which is what you want, no?
> 
> I suppose a base package should do that, not my specific software. Do
> I understand right?

Yes. The notifier works on the root of the cgroup hierarchy so it is a
matter of the admin to set it.
 
> >>  Also my program should work in userspace without the need to use
> >>  release_agent which can be accessed only by root.
> >
> > The release_agent is global for all groups so the program doesn't have
> > to care.
> 
> Again: What MY program should do?

Nothing. (assuming the only thing you are interested in is removing the
empty group).

[...]
-- 
Michal Hocko
SUSE Labs
