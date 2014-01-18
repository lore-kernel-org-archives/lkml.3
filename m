Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaARPKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 10:10:13 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33756 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaARPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 10:10:11 -0500
Date: Sat, 18 Jan 2014 10:10:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH 1/6] cgroup: make CONFIG_NET_CLS_CGROUP and
 CONFIG_NETPRIO_CGROUP bool instead of tristate
Message-ID: <20140118151006.GF3640@htj.dyndns.org>
References: <1389982317-22225-1-git-send-email-tj@kernel.org>
 <1389982317-22225-2-git-send-email-tj@kernel.org>
 <52D9D421.6040608@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D9D421.6040608@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, Jan 18, 2014 at 09:08:49AM +0800, Li Zefan wrote:
> Cc: Daniel Borkmann <dborkman@redhat.com>
> 
> On 2014/1/18 2:11, Tejun Heo wrote:
> > net_cls and net_prio are the only cgroups which are allowed to be
> > built as modules.  The savings from allowing the two controllers to be
> > built as modules are tiny especially given that cgroup module support
> > itself adds quite a bit of complexity.
> > 
> > The following are the sizes of vmlinux with both built as module and
> > both built as part of the kernel image with cgroup module support
> > removed.
> > 
> > 	text		data		bss		dec
> > 	20292207	2411496		10784768	33488471
> > 	20293421	2412568		10784768	33490757
> > 
> > The total difference is 2286 bytes.  Given that none of other
> > controllers has much chance of being made a module and that we're
> > unlikely to add new modular controllers, the added complexity is
> > simply not justifiable.
> > 
> > As a first step to drop cgroup module support, this patch changes the
> > two config options to bool from tristate and drops module related code
> > from the two controllers.
> > 
> 
> I sugguested Daniel to do this for net_cls, and the change has been in
> net-next.
> 
> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=fe1217c4f3f7d7cbf8efdd8dd5fdc7204a1d65a8
> 
> I was planning to remove module support after that change goes into
> upstream. :)

Ooh, cool. :)

Unless there's gonna be another rc, I think it's already a bit too
late for 3.14 anyway.  I'll drop the net_cls part and rebase the
changes on top of rc1 later on.

Thanks.

-- 
tejun
