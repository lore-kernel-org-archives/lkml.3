Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaHIVev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 17:34:51 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53785 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaHIVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 17:34:48 -0400
Date: Sat, 9 Aug 2014 14:34:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v2] mm, hugetlb_cgroup: align hugetlb cgroup limit to
 hugepage size
In-Reply-To: <87mwbem0zo.fsf@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1408091434280.17896@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com> <alpine.DEB.2.02.1408081507180.15603@chino.kir.corp.google.com> <87mwbem0zo.fsf@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2014, Aneesh Kumar K.V wrote:

> > diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> > --- a/mm/hugetlb_cgroup.c
> > +++ b/mm/hugetlb_cgroup.c
> > @@ -275,6 +275,7 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
> >  		ret = res_counter_memparse_write_strategy(buf, &val);
> >  		if (ret)
> >  			break;
> > +		val = ALIGN(val, 1ULL << huge_page_shift(&hstates[idx]));
> 
> Do we really need ULL ? max value should fit in unsigned long right ?
> 

I usually just go for type agreement.

> >  		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
> >  		break;
> >  	default:
> 
> 
