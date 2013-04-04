Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256Ab3DDE5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:57:39 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33367 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763197Ab3DDE5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:57:38 -0400
Message-ID: <515D083A.4010704@gmail.com>
Date: Thu, 04 Apr 2013 12:57:30 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] migrate: add migrate_entry_wait_huge()
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1361475708-25991-2-git-send-email-n-horiguchi@ah.jp.nec.com> <5148FB6C.4070202@gmail.com> <1363816399-c6e7mofc-mutt-n-horiguchi@ah.jp.nec.com> <514A4815.4040206@gmail.com>
In-Reply-To: <514A4815.4040206@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!
On 03/21/2013 07:36 AM, Simon Jeons wrote:
> Hi Naoya,
> On 03/21/2013 05:53 AM, Naoya Horiguchi wrote:
>> On Wed, Mar 20, 2013 at 07:57:32AM +0800, Simon Jeons wrote:
>>> Hi Naoya,
>>> On 02/22/2013 03:41 AM, Naoya Horiguchi wrote:
>>>> When we have a page fault for the address which is backed by a hugepage
>>>> under migration, the kernel can't wait correctly until the migration
>>>> finishes. This is because pte_offset_map_lock() can't get a correct
>>> It seems that current hugetlb_fault still wait hugetlb page under
>>> migration, how can it work without lock 2MB memory?
>> Hugetlb_fault() does call migration_entry_wait(), but returns immediately.
> Could you point out to me which code in function migration_entry_wait()
> lead to return immediately?
>
>> So page fault happens over and over again until the migration completes.
>> IOW, migration_entry_wait() is now broken for hugepage and doesn't work
>> as expected.
>>
>> Thanks,
>> Naoya

