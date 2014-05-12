Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbaELQ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:57:22 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:53173 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759265AbaELQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:57:19 -0400
Date: Mon, 12 May 2014 11:57:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, riel@redhat.com, aarcange@redhat.com,
        oleg@redhat.com, cldu@marvell.com, fabf@skynet.be,
        sasha.levin@oracle.com, zhangyanfei@cn.fujitsu.com,
        iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com,
        kirill.shutemov@linux.intel.com, liwanp@linux.vnet.ibm.com,
        gorcunov@gmail.com, minchan@kernel.org, dave.hansen@linux.intel.com,
        toshi.kani@hp.com, paul.gortmaker@windriver.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/3] mm: add comment for __mod_zone_page_stat
In-Reply-To: <1399912423-25601-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.DEB.2.10.1405121155220.26638@gentwo.org>
References: <1399912423-25601-1-git-send-email-nasa4836@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Jianyu Zhan wrote:

> diff --git a/mm/internal.h b/mm/internal.h
> index 07b6736..53d439e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -196,7 +196,12 @@ static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
>  		return 0;
>
>  	if (!TestSetPageMlocked(page)) {
> -		mod_zone_page_state(page_zone(page), NR_MLOCK,
> +		/*
> +		 * We use the irq-unsafe __mod_zone_page_stat because
> +		 * this counter is not modified from interrupt context, and the
> +		 * pte lock is held(spinlock), which implies preemtion disabled.

Preemption is mis-spelled throughout.

Otherwise

Reviewed-by: Christoph Lameter <cl@linux.com>

