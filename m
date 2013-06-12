Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab3FLVUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:20:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3FLVUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:20:33 -0400
Date: Wed, 12 Jun 2013 14:20:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] mm/page_alloc: don't re-init pageset in
 zone_pcp_update()
Message-Id: <20130612142032.882a28b7911ed24ca19e282e@linux-foundation.org>
In-Reply-To: <1370988779-7586-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1370988779-7586-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013 15:12:59 -0700 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> Factor pageset_set_high_and_batch() (which contains all needed logic too
> set a pageset's ->high and ->batch inrespective of system state) out of
> zone_pageset_init(), which avoids us calling pageset_init(), and
> unsafely blowing away a pageset at runtime (leaked pages and
> potentially some funky allocations would be the result) when memory
> hotplug is triggered.

This changelog is pretty screwed up :( It tells us what the patch does
but not why it does it.

> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
> 
> Unless memory hotplug is being triggered on boot, this should *not* be cause of Valdis
> Kletnieks' reported bug in -next:
>          "next-20130607 BUG: Bad page state in process systemd pfn:127643"

And this addendum appears to hint at the info we need.

Please, send a new changelog?  That should include a description of the
user-visible effects of the bug which is being fixed, a description of
why it occurs and a description of how it was fixed.  It would also be
helpful if you can identify which kernel version(s) need the fix.

Also, a Reported-by:Valdis would be appropriate.

Thanks.
