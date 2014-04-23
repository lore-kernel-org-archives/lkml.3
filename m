Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbaDWPzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696AbaDWPzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:55:17 -0400
Date: Wed, 23 Apr 2014 11:55:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, tj@kernel.org, ssorce@redhat.com,
        lpoetter@redhat.com, kay@redhat.com, luto@amacapital.net,
        dwalsh@redhat.com
Subject: Re: [PATCH 0/2] net: Implement SO_PEERCGROUP and SO_PASSCGROUP
 socket options
Message-ID: <20140423155512.GA24651@redhat.com>
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com>
 <20140422.160558.627080587952506099.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422.160558.627080587952506099.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 04:05:58PM -0400, David Miller wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Tue, 15 Apr 2014 17:15:44 -0400
> 
> > This is another version of patchset to add support passing cgroup
> > information of client over unix socket API.
> 
> I'm marking this patch series as "changes requested" in patchwork
> because if we still end up adding this feature SO_PASSCGROUP needs to
> be changed to behave like SO_PASSCRED.

Does this concern of passing of real uid apply to cgroups also. Even
if somebody tricks suid program to write to fd setup by under priviliged
program how would that pgram force setuid program to change cgroup.

To me passing cgroup information looks more like "pid" information where
we pass the actual pid of setuid program and not the pid of parent who
setup fd.

How would one trick setuid program change cgroup? If not, then this class
of attack does not seem to apply to SO_PASSCGROUP.

So I think real discussion here should be how "cgroup" information should
be used and not necessarily whether we should be passing cgroup
information of sender. This information is already available. One can
do SO_PASSCRED, get pid, get /proc/pid/cgroup and use cgroup in whatever
way they want.

If that's buggy, should we block /proc/pid/cgroup interface because cgroup
info of a process can be used in improper way.

Thanks
Vivek
