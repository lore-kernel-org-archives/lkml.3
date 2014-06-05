Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaFEPAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:00:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaFEPAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:00:31 -0400
Date: Thu, 5 Jun 2014 17:00:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Richard Weinberger <richard@nod.at>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org,
        handai.szj@taobao.com, rientjes@google.com, oleg@redhat.com,
        rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
Message-ID: <20140605150025.GB15939@dhcp22.suse.cz>
References: <1401976841-3899-1-git-send-email-richard@nod.at>
 <1401976841-3899-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401976841-3899-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-06-14 16:00:41, Richard Weinberger wrote:
> Don't spam the kernel logs if the oom_control event fd has listeners.
> In this case there is no need to print that much lines as user space
> will anyway notice that the memory cgroup has reached its limit.

But how do you debug why it is reaching the limit and why a particular
process has been killed?

If we are printing too much then OK, let's remove those parts which are
not that useful but hiding information which tells us more about the oom
decision doesn't sound right to me.

> Signed-off-by: Richard Weinberger <richard@nod.at>
[...]
-- 
Michal Hocko
SUSE Labs
