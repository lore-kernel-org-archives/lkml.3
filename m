Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaBGR53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaBGR51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:57:27 -0500
Message-ID: <52F51E19.9000406@redhat.com>
Date: Fri, 07 Feb 2014 12:55:37 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] drop_caches: add some documentation and info message
References: <1391794851-11412-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1391794851-11412-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 12:40 PM, Johannes Weiner wrote:

> @@ -59,6 +60,9 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
>   	if (ret)
>   		return ret;
>   	if (write) {
> +		printk_ratelimited(KERN_INFO "%s (%d): dropped kernel caches: %d\n",
> +				   current->comm, task_pid_nr(current),
> +				   sysctl_drop_caches);
>   		if (sysctl_drop_caches & 1)
>   			iterate_supers(drop_pagecache_sb, NULL);
>   		if (sysctl_drop_caches & 2)
>

Would it be better to print this after the operation
has completed?
