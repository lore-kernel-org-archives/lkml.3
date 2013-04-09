Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935782Ab3DITLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:11:53 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:59289 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935459Ab3DITLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:11:51 -0400
Date: Tue, 9 Apr 2013 12:11:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Lennart Poettering <lpoetter@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, dhaval.giani@gmail.com, workman-devel@redhat.com
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130409191145.GI6186@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <5162CA21.4060108@parallels.com>
 <51635371.7070104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51635371.7070104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 09, 2013 at 01:32:01AM +0200, Lennart Poettering wrote:
> The other big thing we want from the systemd side is saner
> notifications when cgroups run empty. i.e. currently we don't get
> these at all in containers (since the agent can be only installed
> once, for the host). And the way we get this is awful, via
> kernel-spawned processes. I am looking for a way how I can establish
> a watch on a certain subtree (not just one directory) and get simple
> notifications in a race-free whenever a cgroup runs empty.

Oh yeah, it's horrifying.  There was something going on a while ago
but I couldn't get hold of Eric Paris.  We probably should resurrect
that patch.

As for delegating to namespaces, I'm not exactly sure what to do.  At
least for now, it could be an acceptable trade-off to delegate the
subdirectory with some limits on the number of cgroups / depth of
hierarchy / whatever.  That said, I'm not really fond of the idea.  It
isn't likely to work seamlessly.  The root cgroup is special anyway
and I don't really like the idea of putting NS related stuff directly
into cgroupfs.

Thanks.

-- 
tejun
