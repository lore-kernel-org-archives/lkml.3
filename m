Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3CTXzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:55:35 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:38046 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CTXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:55:34 -0400
Message-ID: <514A4C70.2020303@gmail.com>
Date: Thu, 21 Mar 2013 07:55:28 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] memory-hotplug: enable memory hotplug to handle hugepage
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1361475708-25991-9-git-send-email-n-horiguchi@ah.jp.nec.com> <51490AD8.9050308@gmail.com> <1363817148-rlt5mp5n-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363817148-rlt5mp5n-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naoya,
On 03/21/2013 06:05 AM, Naoya Horiguchi wrote:
> On Wed, Mar 20, 2013 at 09:03:20AM +0800, Simon Jeons wrote:
>> Hi Naoya,
>> On 02/22/2013 03:41 AM, Naoya Horiguchi wrote:
>>> Currently we can't offline memory blocks which contain hugepages because
>>> a hugepage is considered as an unmovable page. But now with this patch
>>> series, a hugepage has become movable, so by using hugepage migration we
>>> can offline such memory blocks.
>>>
>>> What's different from other users of hugepage migration is that we need
>>> to decompose all the hugepages inside the target memory block into free
>> For other hugepage migration users, hugepage should be freed to
>> hugepage_freelists after migration, but why I don't see any codes do
>> this?
> The source hugepages which are migrated by NUMA related system calls
> (migrate_pages(2), move_pages(2), and mbind(2)) are still useable,
> so we simply free them into free hugepage pool.

It seems that you misunderstand why I confuse. I can't find where free
huge pages to hugepage pool, could you point out to me?

> OTOH, the source hugepages migrated by memory hotremove should not be
> reusable, because users of memory hotremove want to remove the memory
> from the system. So we need to free such hugepages forcibly into the
> buddy pages, otherwise memory offining doesn't work.
>
> Thanks,
> Naoya

