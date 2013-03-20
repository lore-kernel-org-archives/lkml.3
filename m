Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3CTWGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:06:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3CTWGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:06:02 -0400
Date: Wed, 20 Mar 2013 18:05:48 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-ID: <1363817148-rlt5mp5n-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <51490AD8.9050308@gmail.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-9-git-send-email-n-horiguchi@ah.jp.nec.com>
 <51490AD8.9050308@gmail.com>
Subject: Re: [PATCH 8/9] memory-hotplug: enable memory hotplug to handle
 hugepage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <51490AD8.9050308@gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 09:03:20AM +0800, Simon Jeons wrote:
> Hi Naoya,
> On 02/22/2013 03:41 AM, Naoya Horiguchi wrote:
> >Currently we can't offline memory blocks which contain hugepages because
> >a hugepage is considered as an unmovable page. But now with this patch
> >series, a hugepage has become movable, so by using hugepage migration we
> >can offline such memory blocks.
> >
> >What's different from other users of hugepage migration is that we need
> >to decompose all the hugepages inside the target memory block into free
> 
> For other hugepage migration users, hugepage should be freed to
> hugepage_freelists after migration, but why I don't see any codes do
> this?

The source hugepages which are migrated by NUMA related system calls
(migrate_pages(2), move_pages(2), and mbind(2)) are still useable,
so we simply free them into free hugepage pool.
OTOH, the source hugepages migrated by memory hotremove should not be
reusable, because users of memory hotremove want to remove the memory
from the system. So we need to free such hugepages forcibly into the
buddy pages, otherwise memory offining doesn't work.

Thanks,
Naoya
