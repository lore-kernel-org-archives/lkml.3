Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaGHVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:53:57 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45104 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGHVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:53:55 -0400
Date: Tue, 8 Jul 2014 17:53:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, mhocko@suse.cz, axboe@kernel.dk
Subject: Re: [PATCH v2 6/6] blkcg, memcg: make blkcg depend on memcg on the
 default hierarchy
Message-ID: <20140708215351.GJ4979@htj.dyndns.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
 <1403917392-32555-7-git-send-email-tj@kernel.org>
 <20140628114907.GA10829@htj.dyndns.org>
 <20140708194226.GA18382@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708194226.GA18382@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Jul 08, 2014 at 03:42:26PM -0400, Vivek Goyal wrote:
> I have couple questions about new semantics. Following is my
> understanding. Is it right?
> 
> - So after this change one can not use blkio controller on unified
>   hiearchy if memory controller is mounted on some other hierarchy
>   and is not available for mounting unified hiearchy.

Hmmm?  No, the only behavior which changes is when both blkcg and
memcg are mounted on the unified hierarchy.  Nothing else changes.
The dependency behavior kicks in iff memcg is available on the unified
hierarchy.

> - If blkio controller is enabled on unified hiearchy (memory controller
>   implicitly enabled), then one can't mount memory controller on other
>   hierarchies without first disabling blkio controller on unified hiearchy.

Yes, blkio needs to be disabled to the root for memcg to be able to
become free.  This is an extra restriction but I don't think it's
anything drastic.  Once a controller starts being actively used on any
hierarchy, nothing has been guaranteed about when the controller would
become free again even if the whole hierarchy is reduced to the root.

Thanks.

-- 
tejun
