Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaFEOT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaFEOT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:19:58 -0400
Date: Thu, 5 Jun 2014 16:18:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        vdavydov@parallels.com, tj@kernel.org, handai.szj@taobao.com,
        rientjes@google.com, rusty@rustcorp.com.au,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
	has listeners
Message-ID: <20140605141841.GA23796@redhat.com>
References: <1401976841-3899-1-git-send-email-richard@nod.at> <1401976841-3899-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401976841-3899-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Richard Weinberger wrote:
>
> +int mem_cgroup_has_listeners(struct mem_cgroup *memcg)
> +{
> +	int ret = 0;
> +
> +	if (!memcg)
> +		goto out;
> +
> +	spin_lock(&memcg_oom_lock);
> +	ret = !list_empty(&memcg->oom_notify);
> +	spin_unlock(&memcg_oom_lock);
> +
> +out:
> +	return ret;
> +}

Do we really need memcg_oom_lock to check list_empty() ? With or without
this lock we can race with list_add/del anyway, and I guess we do not care.

And perhaps the caller should check memcg != NULL. but this is subjective,
I won't argue.

Oleg.

