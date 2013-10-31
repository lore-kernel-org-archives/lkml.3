Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3JaEzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:55:46 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58289 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3JaEzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:55:44 -0400
Message-ID: <5271E2CC.8040702@gmail.com>
Date: Thu, 31 Oct 2013 00:55:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: kosaki.motohiro@gmail.com, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Do not walk all of system memory during show_mem
References: <20131016104228.GM11028@suse.de>
In-Reply-To: <20131016104228.GM11028@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/16/13 6:42 AM), Mel Gorman wrote:
> It has been reported on very large machines that show_mem is taking almost
> 5 minutes to display information. This is a serious problem if there is
> an OOM storm. The bulk of the cost is in show_mem doing a very expensive
> PFN walk to give us the following information
>
> Total RAM:	Also available as totalram_pages
> Highmem pages:	Also available as totalhigh_pages
> Reserved pages:	Can be inferred from the zone structure
> Shared pages:	PFN walk required
> Unshared pages:	PFN walk required
> Quick pages:	Per-cpu walk required
>
> Only the shared/unshared pages requires a full PFN walk but that information
> is useless. It is also inaccurate as page pins of unshared pages would
> be accounted for as shared.  Even if the information was accurate, I'm
> struggling to think how the shared/unshared information could be useful
> for debugging OOM conditions. Maybe it was useful before rmap existed when
> reclaiming shared pages was costly but it is less relevant today.
>
> The PFN walk could be optimised a bit but why bother as the information is
> useless. This patch deletes the PFN walker and infers the total RAM, highmem
> and reserved pages count from struct zone. It omits the shared/unshared page
> usage on the grounds that it is useless.  It also corrects the reporting
> of HighMem as HighMem/MovableOnly as ZONE_MOVABLE has similar problems to
> HighMem with respect to lowmem/highmem exhaustion.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

That's ok. I haven't used such information on my long oom debugging history.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


