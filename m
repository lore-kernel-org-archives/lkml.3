Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3IOS40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 14:56:26 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:55091 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3IOS4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 14:56:25 -0400
Date: Sun, 15 Sep 2013 14:56:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hughd@google.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 1/2 v3] memcg: refactor mem_control_numa_stat_show()
Message-ID: <20130915185613.GB3278@cmpxchg.org>
References: <1378362539-18100-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378362539-18100-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Sep 04, 2013 at 11:28:58PM -0700, Greg Thelen wrote:
> +	struct numa_stat {
> +		const char *name;
> +		unsigned int lru_mask;
> +	};
> +
> +	static const struct numa_stat stats[] = {
> +		{ "total", LRU_ALL },
> +		{ "file", LRU_ALL_FILE },
> +		{ "anon", LRU_ALL_ANON },
> +		{ "unevictable", BIT(LRU_UNEVICTABLE) },
> +		{ NULL, 0 }  /* terminator */
> +	};

[...]

> +	for (stat = stats; stat->name; stat++) {

Please drop the NULL terminator and use ARRAY_SIZE().

Otherwise, looks good to me.
