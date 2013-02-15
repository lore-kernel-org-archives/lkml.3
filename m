Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3BOINr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:13:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57494 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3BOINq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:13:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <511DEE21.9030700@jp.fujitsu.com>
Date: Fri, 15 Feb 2013 17:13:21 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 2/6] memcg: rework mem_cgroup_iter to use cgroup iterators
References: <1360848396-16564-1-git-send-email-mhocko@suse.cz> <1360848396-16564-3-git-send-email-mhocko@suse.cz> <511DEBBD.1050102@jp.fujitsu.com> <20130215081122.GB31032@dhcp22.suse.cz>
In-Reply-To: <20130215081122.GB31032@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/02/15 17:11), Michal Hocko wrote:
> On Fri 15-02-13 17:03:09, KAMEZAWA Hiroyuki wrote:
				css_get(&curr->css);
>> I'm sorry if I miss something...
>>
>> This curr is  curr == memcg = mem_cgroup_from_css(css) <= already try_get() done.
>> double refcounted ?
>
> Yes we get 2 references here. One for the returned memcg - which will be
> released either by mem_cgroup_iter_break or a next iteration round
> (where it would be prev) and the other is for last_visited which is
> released when a new memcg is cached.
>
Sure.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

