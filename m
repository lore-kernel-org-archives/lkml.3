Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaFYMeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:34:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63763 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaFYMeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:34:00 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-99-53aac1b5160a
Message-id: <53AAC1B4.5000204@samsung.com>
Date: Wed, 25 Jun 2014 14:33:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v3 -next 0/9] CMA: generalize CMA reserved area management
 code
References: <1402897251-23639-1-git-send-email-iamjoonsoo.kim@lge.com>
 <539EB4C7.3080106@samsung.com> <20140617012507.GA6825@js1304-P5Q-DELUXE>
 <20140618135144.297c785260f9e2aebead867c@linux-foundation.org>
In-reply-to: <20140618135144.297c785260f9e2aebead867c@linux-foundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xy7pbD64KNri2g9PixJV/jBZz1q9h
	s3j8eh6LxYemVmaLLz+vM1o0L17PZrGyu5nN4s0nbYs5UwstNj2+xmpxedccNot7a/6zWty+
	zGvx+/s/VosFx1tYLZZ9fc9usebIYnaL/duAYpeOz2R2EPZoae5h8/h/cBKzR8+bFlaPTas6
	2Tw2fZrE7tH19gqTx4kZv1k8HhzazOKxf+4ado/NS+o9zs9YyOix7s8rJo/3+66yeczd1cfo
	sfl0tcfnTXIBAlFcNimpOZllqUX6dglcGX/33mUt+MpXcbKdvYHxA3cXIyeHhICJxNS339kg
	bDGJC/fWA9lcHEICSxklPh6cwgLhfGKUaF9/lxWkildAS6Jz2VxmEJtFQFViy5NtYN1sAoYS
	XW+7wGxRgRiJM72fmSHqBSV+TL7HAmKLCIRKbFnYxwQylFmghVWiadUSsKHCQInDJ3sZIbZd
	YpQ40reSHSTBKeAtcXHZB0YQm1nATOJRyzpmCFteYvOat8wTGAVmIVkyC0nZLCRlCxiZVzGK
	ppYmFxQnpeca6hUn5haX5qXrJefnbmKERPGXHYyLj1kdYhTgYFTi4Q3gWRUsxJpYVlyZe4hR
	goNZSYTXfT9QiDclsbIqtSg/vqg0J7X4ECMTB6dUA+Mm1VWiR6rqly+tkL7q8+z8pPXrLny6
	pPvH40FF5KaiBzcOfd765HHkE3lpvw2r/4s/fzBtQme8fEiAuNKRyd22bBbsAg92hYkEO5/9
	/PHqzl/TuuYuln7us23JopCVtun59mutj4ctOVZ4bJHAjLncDWuLOkztonK3POH7mqTK/8Hw
	1ROxbKkrSizFGYmGWsxFxYkAtXxUWsACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-06-18 22:51, Andrew Morton wrote:
> On Tue, 17 Jun 2014 10:25:07 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>>>> v2:
>>>>    - Although this patchset looks very different with v1, the end result,
>>>>    that is, mm/cma.c is same with v1's one. So I carry Ack to patch 6-7.
>>>>
>>>> This patchset is based on linux-next 20140610.
>>> Thanks for taking care of this. I will test it with my setup and if
>>> everything goes well, I will take it to my -next tree. If any branch
>>> is required for anyone to continue his works on top of those patches,
>>> let me know, I will also prepare it.
>> Hello,
>>
>> I'm glad to hear that. :)
>> But, there is one concern. As you already know, I am preparing further
>> patches (Aggressively allocate the pages on CMA reserved memory). It
>> may be highly related to MM branch and also slightly depends on this CMA
>> changes. In this case, what is the best strategy to merge this
>> patchset? IMHO, Anrew's tree is more appropriate branch. If there is
>> no issue in this case, I am willing to develope further patches based
>> on your tree.
> That's probably easier.  Marek, I'll merge these into -mm (and hence
> -next and git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git)
> and shall hold them pending you review/ack/test/etc, OK?

Ok. I've tested them and they work fine. I'm sorry that you had to wait for
me for a few days. You can now add:

Acked-and-tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

I've also rebased my pending patches onto this set (I will send them soon).

The question is now if you want to keep the discussed patches in your 
-mm tree,
or should I take them to my -next branch. If you like to keep them, I assume
you will also take the patches which depends on the discussed changes.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

