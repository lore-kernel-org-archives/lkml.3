Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3ANWf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:35:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758849Ab3ANWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:35:24 -0500
Date: Mon, 14 Jan 2013 14:35:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v5 2/5] page_alloc: add movable_memmap kernel parameter
Message-Id: <20130114143512.b961211e.akpm@linux-foundation.org>
In-Reply-To: <1358154925-21537-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
	<1358154925-21537-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 17:15:22 +0800
Tang Chen <tangchen@cn.fujitsu.com> wrote:

> This patch adds functions to parse movablecore_map boot option. Since the
> option could be specified more then once, all the maps will be stored in
> the global variable movablecore_map.map array.
> 
> And also, we keep the array in monotonic increasing order by start_pfn.
> And merge all overlapped ranges.
> 
> ...
>
> +#define MOVABLECORE_MAP_MAX MAX_NUMNODES
> +struct movablecore_entry {
> +	unsigned long start_pfn;    /* start pfn of memory segment */
> +	unsigned long end_pfn;      /* end pfn of memory segment */

It is important to tell readers whether an "end" is inclusive or
exclusive.  ie: does it point at the last byte, or one beyond it?

By reading the code I see it is exclusive, so...

--- a/include/linux/mm.h~page_alloc-add-movable_memmap-kernel-parameter-fix
+++ a/include/linux/mm.h
@@ -1362,7 +1362,7 @@ extern void sparse_memory_present_with_a
 #define MOVABLECORE_MAP_MAX MAX_NUMNODES
 struct movablecore_entry {
 	unsigned long start_pfn;    /* start pfn of memory segment */
-	unsigned long end_pfn;      /* end pfn of memory segment */
+	unsigned long end_pfn;      /* end pfn of memory segment (exclusive) */
 };
 
 struct movablecore_map {

