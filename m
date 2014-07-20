Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaGTTvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:51:31 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:60785 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaGTTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:51:29 -0400
Message-ID: <53CC1DBD.2020202@suse.cz>
Date: Sun, 20 Jul 2014 21:51:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.12 100/170] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz> <c56d55d645be041c808e1dc363a4ebbe5228025a.1405685481.git.jslaby@suse.cz> <alpine.LSU.2.11.1407181146250.3308@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1407181146250.3308@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 08:53 PM, Hugh Dickins wrote:
> On Fri, 18 Jul 2014, Jiri Slaby wrote:
> 
>> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>>
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ===============
>>
>> commit 4a705fef986231a3e7a6b1a6d3c37025f021f49f upstream.
>>
>> There's a race between fork() and hugepage migration, as a result we try
>> to "dereference" a swap entry as a normal pte, causing kernel panic.
>> The cause of the problem is that copy_hugetlb_page_range() can't handle
>> "swap entry" family (migration entry and hwpoisoned entry) so let's fix
>> it.
>>
>> [akpm@linux-foundation.org: coding-style fixes]
>> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Acked-by: Hugh Dickins <hughd@google.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Please drop this one for now: other -stables have carried it, but it
> was found yesterday to contain a bug of its own, arguably worse than
> what it's fixing.  Naoya-san has done the fix for that, it's in mmotm
> and should make its way to Linus probably next week: so please hold
> this back until that can join it - thanks.

Thanks, I dropped it later on Fri already after Guillaume informed me
about this.

-- 
js
suse labs
