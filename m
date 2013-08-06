Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3HFBwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:52:09 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48082 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3HFBwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:52:08 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 8/8] prepare to remove /proc/sys/vm/hugepages_treat_as_movable
In-Reply-To: <1375411396-bw4cbhso-mutt-n-horiguchi@ah.jp.nec.com>
References: <1374728103-17468-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1374728103-17468-9-git-send-email-n-horiguchi@ah.jp.nec.com> <87k3k7q4ox.fsf@linux.vnet.ibm.com> <1375302249-scfvftrh-mutt-n-horiguchi@ah.jp.nec.com> <87vc3qvtmc.fsf@linux.vnet.ibm.com> <1375411396-bw4cbhso-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 06 Aug 2013 07:22:02 +0530
Message-ID: <87haf3oabh.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080601-2674-0000-0000-00000A1DA302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:


>> 
>> Considering that we have architectures that won't support migrating
>> explicit hugepages with this patch series, is it ok to use
>> GFP_HIGHUSER_MOVABLE for hugepage allocation ?
>
> Originally this parameter was introduced to make hugepage pool on ZONE_MOVABLE.
> The benefit is that we can extend the hugepage pool more easily,
> because external fragmentation less likely happens than other zone type
> by rearranging fragmented pages with page migration/reclaim.
>
> So I think using ZONE_MOVABLE for hugepage allocation by default makes sense
> even on the architectures which don't support hugepage migration.

But allocating hugepages from ZONE_MOVABLE means we have pages in that
zone which we can't migrate. Doesn't that impact other features like
hotplug ?


-aneesh

