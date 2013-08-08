Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965832Ab3HHPUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:20:30 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:42578 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965775Ab3HHPU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:20:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130807153030.GA25515@redhat.com>
References: <20130807055157.GA32278@redhat.com>
	<CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
	<20130807153030.GA25515@redhat.com>
Date: Thu, 8 Aug 2013 23:20:28 +0800
Message-ID: <CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
Subject: Re: unused swap offset / bad page map.
From: Hillf Danton <dhillf@gmail.com>
To: Dave Jones <davej@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 11:30 PM, Dave Jones <davej@redhat.com> wrote:
> printk didn't trigger.
>
Is a corrupted page table entry encountered, according to the
comment of swap_duplicate()?


--- a/mm/swapfile.c	Wed Aug  7 17:27:22 2013
+++ b/mm/swapfile.c	Thu Aug  8 23:12:30 2013
@@ -770,6 +770,7 @@ int free_swap_and_cache(swp_entry_t entr
 		unlock_page(page);
 		page_cache_release(page);
 	}
+	return 1;
 	return p != NULL;
 }

--
