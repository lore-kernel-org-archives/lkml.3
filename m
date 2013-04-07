Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161306Ab3DGBcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 21:32:12 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:38294 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161182Ab3DGBcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 21:32:11 -0400
Message-ID: <5160CC94.6040909@gmail.com>
Date: Sun, 07 Apr 2013 09:32:04 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: fixup changers of per cpu pageset's ->high and
 ->batch
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cody,
On 04/06/2013 04:33 AM, Cody P Schafer wrote:
> In one case while modifying the ->high and ->batch fields of per cpu pagesets
> we're unneededly using stop_machine() (patches 1 & 2), and in another we don't have any
> syncronization at all (patch 3).

Do you mean stop_machine() is used for syncronization between each 
online cpu?

>
> This patchset fixes both of them.
>
> Note that it results in a change to the behavior of zone_pcp_update(), which is
> used by memory_hotplug. I _think_ that I've diserned (and preserved) the
> essential behavior (changing ->high and ->batch), and only eliminated unneeded
> actions (draining the per cpu pages), but this may not be the case.
>
> --
>   mm/page_alloc.c | 63 +++++++++++++++++++++++++++------------------------------
>   1 file changed, 30 insertions(+), 33 deletions(-)
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

