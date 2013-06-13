Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab3FMCfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:35:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19453 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3FMCfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:35:17 -0400
Message-ID: <51B92FD0.8020907@huawei.com>
Date: Thu, 13 Jun 2013 10:34:56 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <koverstreet@google.com>, <linux-kernel@vger.kernel.org>,
        <cl@linux-foundation.org>
Subject: Re: [PATCH 03/11] cgroup: bring some sanity to naming around cg_cgroup_link
References: <1371070996-20613-1-git-send-email-tj@kernel.org> <1371070996-20613-4-git-send-email-tj@kernel.org>
In-Reply-To: <1371070996-20613-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/13 5:03, Tejun Heo wrote:
> cgroups and css_sets are mapped M:N and this M:N mapping is
> represented by struct cg_cgroup_link which points to forms linked
> lists on both sides.  The naming around this already confusing struct
> is pretty bad.
> 
>>From cgroup side, it starts off ->css_sets and runs through
> ->cgrp_link_list.  From css_set side, it starts off ->cg_links and
> runs through ->cg_link_list.  This is rather reversed as
> cgrp_link_list is used to iterate css_sets and cg_link_list cgroups.
> Also, this is the only place which is still using the confusing "cg"
> for css_sets.  This patch cleans it up a bit.
> 
> * s/cgroup->css_sets/cgroup->cset_links/
>   s/css_set->cg_links/css_set->cgrp_links/
>   s/cgroup_iter->cg_link/cgroup_iter->cset_link/
> 
> * s/cg_cgroup_link/cgrp_cset_link/
> 
> * s/cgrp_cset_link->cg/cgrp_cset_link->cset/
>   s/cgrp_cset_link->cgrp_link_list/cgrp_cset_link->cset_link/
>   s/cgrp_cset_link->cg_link_list/cgrp_cset_link->cgrp_link/
> 
> * s/init_css_set_link/init_cgrp_cset_link/
>   s/free_cg_links/free_cgrp_cset_links/
>   s/allocate_cg_links/allocate_cgrp_cset_links/
> 
> * s/cgl[12]/link[12]/ in compare_css_sets()
> 
> * s/saved_link/tmp_link/ s/tmp/tmp_links/ and a couple similar
>   adustments.
> 
> * Comment and whiteline adjustments.
> 
> After the changes, we have
> 
> 	list_for_each_entry(link, &cont->cset_links, cset_link) {
> 		struct css_set *cset = link->cset;
> 
> instead of
> 
> 	list_for_each_entry(link, &cont->css_sets, cgrp_link_list) {
> 		struct css_set *cset = link->cg;
> 

Those renames really make the code more readable! I have to think for a while
everytime I see those namings.

