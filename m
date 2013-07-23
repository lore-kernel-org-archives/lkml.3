Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab3GWSjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:39:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56168 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab3GWSit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:38:49 -0400
Date: Tue, 23 Jul 2013 13:38:41 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20130723183841.GA9021@tp>
References: <20130723181606.GA6342@sergelap>
 <20130723183018.GF21100@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723183018.GF21100@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> On Tue, Jul 23, 2013 at 01:16:06PM -0500, Serge Hallyn wrote:
> > We allow a task to change its own devices cgroup, or to change other tasks'
> > cgroups if it has CAP_SYS_ADMIN.
> > 
> > Also allow task A to change task B's cgroup if task A has CAP_SYS_ADMIN
> > with respect to task B - meaning A is root in the same userns, or A
> > created B's userns.
> 
> As discussed multpile times, cgroup isn't gonna support delegating
> cgroup management directly into containers, so this doesn't really
> jive with where we're heading.

This doesn't delegate it into the container.  It allows me, on the host,
to set the cgroup for a container.

thanks,
-serge
