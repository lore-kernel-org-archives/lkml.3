Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935834Ab3DHTqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935748Ab3DHTqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:46:37 -0400
Date: Mon, 8 Apr 2013 15:46:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, bsingharora@gmail.com,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter@redhat.com,
        linux-kernel@vger.kernel.org, dhaval.giani@gmail.com,
        workman-devel@redhat.com
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130408194630.GH28292@redhat.com>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130408175925.GE28292@redhat.com>
 <20130408181607.GI3021@htj.dyndns.org>
 <20130408191105.GG28292@redhat.com>
 <20130408192024.GL3021@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408192024.GL3021@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:20:24PM -0700, Tejun Heo wrote:

[..]
> > For example, one might want to say that maximum IO bandwidth for 
> > virtual machine virt1 on disk sda should be 10MB/s. Now libvirt
> > should be able to save it in virtual machine specific configuration
> > easily and whenever virtual machine is started, create a children
> > cgroup, set the limits as specified.
> 
> Yes, sure, libvirt can *request* whatever it seems appropriate to the
> central authority, which will decide whether it'll be able to honor
> the request and grant it if possible and allowed by policies in
> effect.

10MB/s is an absolute limit. So I guess there is nothing to be requested
from an central authority here in terms of resources.

Even in the case of IO weight or cpu shares, there is nothing to be asked
from central authority. Well, there is. Creation of new croups changes
effective %share of peer groups. More below.

Where it makes sense though is if one says give a particular service
25% cpu. Then suddenly all the peer and parent entities become important.
IIUC, initial draft of workman does not address this issue.

It would be good to think more about it. How a user can ensure minimum
resources to a partition/service. Because in that case at every level
somebody needs to keep track how much of resources have been committed
as minimum requirements and more consumers can't be allowed at same level.
(This sounds like cpu RT time division among various cgroups).

Thanks
Vivek
