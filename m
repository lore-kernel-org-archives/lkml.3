Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaLRAiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:38:14 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33825 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaLRAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:38:12 -0500
Date: Wed, 17 Dec 2014 16:38:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: akpm@linux-foundation.org, Dmitry Vyukov <dvyukov@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "nadia.derbey@bull.net" <Nadia.Derbey@bull.net>, aquini@redhat.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] hugetlb, sysctl: pass '.extra1 = NULL' rather then
 '.extra1 = &zero'
In-Reply-To: <1418826650-10145-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.10.1412171636400.23841@chino.kir.corp.google.com>
References: <548CA6B6.3060901@colorfullife.com> <1418826650-10145-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Andrey Ryabinin wrote:

> Commit ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity") replaced
> 'unsigned long hugetlb_zero' with 'int zero' leading to out-of-bounds access
> in proc_doulongvec_minmax().
> Use '.extra1 = NULL' instead of '.extra1 = &zero'. Passing NULL is equivalent to
> passing minimal value, which is 0 for unsigned types.
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Suggested-by: Manfred Spraul <manfred@colorfullife.com>
> Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Acked-by: David Rientjes <rientjes@google.com>

Patch title is a little awkward, though, maybe "mm, hugetlb: remove 
unnecessary lower bound on sysctl handlers"?
