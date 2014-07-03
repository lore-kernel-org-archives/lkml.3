Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaGCCFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:05:07 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:12022 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaGCCFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:05:03 -0400
Message-ID: <1404353082.23839.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [patch] mm, hugetlb: generalize writes to nr_hugepages
From: Davidlohr Bueso <davidlohr@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 02 Jul 2014 19:04:42 -0700
In-Reply-To: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 16:57 -0700, David Rientjes wrote:
> Three different interfaces alter the maximum number of hugepages for an
> hstate:
> 
>  - /proc/sys/vm/nr_hugepages for global number of hugepages of the default
>    hstate,
> 
>  - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages for global number of
>    hugepages for a specific hstate, and
> 
>  - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages/mempolicy for number of
>    hugepages for a specific hstate over the set of allowed nodes.
> 
> Generalize the code so that a single function handles all of these writes 
> instead of duplicating the code in two different functions.
> 
> This decreases the number of lines of code, but also reduces the size of
> .text by about half a percent since set_max_huge_pages() can be inlined.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

