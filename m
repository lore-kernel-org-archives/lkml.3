Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab3CLTAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:00:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:44515 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3CLTAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:00:37 -0400
Message-ID: <513F7B55.60805@tilera.com>
Date: Tue, 12 Mar 2013 15:00:37 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/1] mm/hugetlb: add more arch-defined huge_pte_xxx functions
References: <1363114106-30251-1-git-send-email-gerald.schaefer@de.ibm.com> <1363114106-30251-2-git-send-email-gerald.schaefer@de.ibm.com>
In-Reply-To: <1363114106-30251-2-git-send-email-gerald.schaefer@de.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2013 2:48 PM, Gerald Schaefer wrote:
> Commit abf09bed3c "s390/mm: implement software dirty bits" introduced
> another difference in the pte layout vs. the pmd layout on s390,
> thoroughly breaking the s390 support for hugetlbfs. This requires
> replacing some more pte_xxx functions in mm/hugetlbfs.c with a
> huge_pte_xxx version.
>
> This patch introduces those huge_pte_xxx functions and their
> implementation on all architectures supporting hugetlbfs. This change
> will be a no-op for all architectures other than s390.
>
> [...]
>  
> +static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
> +{
> +	return mk_pte(page, pgprot);
> +}

Does it make sense to merge this new per-arch function with the existing per-arch arch_make_huge_pte() function?  Certainly in the tile case, we could set up our "super" bit in the initial mk_huge_pte() call, and then set "young" and "huge" after that in the platform-independent caller (make_huge_pte).  This would allow your change to eliminate some code as well as just introducing code :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

