Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3FFVY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:24:56 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53890 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3FFVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:24:54 -0400
Date: Thu, 6 Jun 2013 14:24:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v2 08/10] cpuset: allow to keep tasks in empty cpusets
Message-ID: <20130606212450.GI5045@htj.dyndns.org>
References: <51AF0183.8070602@huawei.com>
 <51AF020B.3030701@huawei.com>
 <20130605205146.GI10693@mtj.dyndns.org>
 <51B063E6.30107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B063E6.30107@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Jun 06, 2013 at 06:26:46PM +0800, Li Zefan wrote:
> > I wonder whether it'd be possible to merge the two paths.  My
> > suspicion is that we probably don't need propagate_hotplug_work
> > anymore now that we can drop RCU read lock while doing the pre-order
> > walk.  What do you think?
> 
> It indeed can be confusing. I'll see if we can make the code clearer.

Yeah, if possible, it'd be great to remove the propagation work item
and do things inline first and then add the new online propagation.

Thanks!

-- 
tejun
