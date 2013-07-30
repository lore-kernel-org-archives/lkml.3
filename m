Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3G3Sck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:32:40 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49475 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3G3Scj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:32:39 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 8/8] prepare to remove /proc/sys/vm/hugepages_treat_as_movable
In-Reply-To: <1374728103-17468-9-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1374728103-17468-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1374728103-17468-9-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 31 Jul 2013 00:02:30 +0530
Message-ID: <87k3k7q4ox.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073018-8256-0000-0000-00000894A0D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Now hugepages are definitely movable. So allocating hugepages from
> ZONE_MOVABLE is natural and we have no reason to keep this parameter.
> In order to allow userspace to prepare for the removal, let's leave
> this sysctl handler as noop for a while.

I guess you still need to handle architectures for which pmd_huge is

int pmd_huge(pmd_t pmd)
{
	return 0;
}

embedded powerpc is one. They don't store pte information at the PMD
level. Instead pmd contains a pointer to hugepage directory which
contain huge pte.

-aneesh

