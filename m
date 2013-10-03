Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3JCKfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:35:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:44079 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3JCKfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:35:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 06/14] vrange: Add basic functions to purge volatile
 pages
Date: Thu, 03 Oct 2013 12:22:24 +0200
Message-ID: <1380795744.3392.3.camel@AMDC1943>
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org>
	 <1380761503-14509-7-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 217-67-201-162.itsa.net.pl
In-Reply-To: <1380761503-14509-7-git-send-email-john.stultz@linaro.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2013-10-02 at 17:51 -0700, John Stultz wrote:
> +static void try_to_discard_one(struct vrange_root *vroot, struct page *page,
> +				struct vm_area_struct *vma, unsigned long addr)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	pte_t *pte;
> +	pte_t pteval;
> +	spinlock_t *ptl;
> +
> +	VM_BUG_ON(!PageLocked(page));
> +
> +	pte = page_check_address(page, mm, addr, &ptl, 0);
> +	if (!pte)
> +		return;
> +
> +	BUG_ON(vma->vm_flags & (VM_SPECIAL|VM_LOCKED|VM_MIXEDMAP|VM_HUGETLB));
> +
> +	flush_cache_page(vma, addr, page_to_pfn(page));

It seems that this patch is different in your GIT repo
(git://git.linaro.org/people/jstultz/android-dev.git dev/vrange-v9). In
GIT it is missing the fix: s/address/addr.

Best regards,
Krzysztof



