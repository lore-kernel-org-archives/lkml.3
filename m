Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3FLWAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:00:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39758 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3FLWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:00:32 -0400
Message-ID: <51B8ED17.2060608@linux.vnet.ibm.com>
Date: Wed, 12 Jun 2013 14:50:15 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] mm/page_alloc: don't re-init pageset in zone_pcp_update()
References: <1370988779-7586-1-git-send-email-cody@linux.vnet.ibm.com> <20130612142032.882a28b7911ed24ca19e282e@linux-foundation.org> <51B8EC10.6070304@linux.vnet.ibm.com>
In-Reply-To: <51B8EC10.6070304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061221-5406-0000-0000-0000097C3EA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyhow, a reorganized (and clearer) changelog with the same content
> follows:
> ---

I made a few wording tweaks:
---
mm/page_alloc: don't re-init pageset in zone_pcp_update()

When memory hotplug is triggered, we call pageset_init() on
per-cpu-pagesets which both contain pages and are in use, causing both
the leakage of those pages and (potentially) bad behaviour if a page is
allocated from a pageset while it is being cleared.

Avoid this by factoring out pageset_set_high_and_batch() (which contains 
all needed logic too set a pageset's ->high and ->batch inrespective of 
system state) from zone_pageset_init() and using the new 
pageset_set_high_and_batch() instead of zone_pageset_init() in 
zone_pcp_update().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>




