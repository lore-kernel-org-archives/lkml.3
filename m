Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936874Ab3DJVqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:46:11 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:34301 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935291Ab3DJVqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:46:09 -0400
Date: Wed, 10 Apr 2013 14:46:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH v5 1/3] hugetlbfs: stop setting VM_DONTDUMP in
 initializing vma(VM_HUGETLB)
In-Reply-To: <1365610669-16625-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.02.1304101445520.1526@chino.kir.corp.google.com>
References: <1365610669-16625-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365610669-16625-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Naoya Horiguchi wrote:

> Currently we fail to include any data on hugepages into coredump,
> because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
> introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
> mm->reserved_vm counter". This looks to me a serious regression,
> so let's fix it.
> 
> ChangeLog v3:
>  - move 'return 0' into a separate patch
> 
> ChangeLog v2:
>  - add 'return 0' in hugepage memory check
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: stable@vger.kernel.org

Acked-by: David Rientjes <rientjes@google.com>

Stable for 3.7+.
