Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaFCP7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:59:50 -0400
Received: from www.sr71.net ([198.145.64.142]:48582 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbaFCP7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:59:49 -0400
Message-ID: <538DF0F1.5070104@sr71.net>
Date: Tue, 03 Jun 2014 08:59:45 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH -mm] mincore: apply page table walker on do_mincore()
 (Re: [PATCH 00/10] mm: pagewalk: huge page cleanups and VMA passing)
References: <20140602213644.925A26D0@viggo.jf.intel.com> <1401745925-l651h3s9@n-horiguchi@ah.jp.nec.com> <538CF25E.8070905@sr71.net> <1401776292-dn0fof8e@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401776292-dn0fof8e@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 11:18 PM, Naoya Horiguchi wrote:
> +	/*
> +	 * Huge pages are always in RAM for now, but
> +	 * theoretically it needs to be checked.
> +	 */
> +	present = pte && !huge_pte_none(huge_ptep_get(pte));
> +	for (; addr != end; vec++, addr += PAGE_SIZE)
> +		*vec = present;
> +	cond_resched();
> +	walk->private += (end - addr) >> PAGE_SHIFT;

That comment is bogus, fwiw.  Huge pages are demand-faulted and it's
quite possible that they are not present.
