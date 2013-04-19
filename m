Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3DSSgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:36:25 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:57962 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3DSSgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:36:23 -0400
Date: Fri, 19 Apr 2013 11:36:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask
 in an empty cpuset
Message-ID: <20130419183618.GC13811@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <51713819.8050708@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51713819.8050708@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Fri, Apr 19, 2013 at 08:27:05PM +0800, Li Zefan wrote:
> I think this was introduced unintentionally when cpuset hotplug was
> made asynchronous. Fortunately it does no harm, as updating tasks'
> cpumask will just return failure and there's a guarantee_online_mems()
> when updating nodemask, and then the tasks will be moved to an ancestor
> cpuset.

Yeah, which will update the masks to the proper values anyway, so it
was intentionally written that way as it didn't really matter either
way.  I suppose this helps future changes?  Maybe update the
description a bit?

Thanks.

-- 
tejun
