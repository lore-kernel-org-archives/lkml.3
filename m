Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3EVAdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:33:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3EVAdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:33:52 -0400
Date: Tue, 21 May 2013 17:33:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Minkyung Kim <minkyung88@lge.com>
Subject: Re: [PATCH v5 6/7] mm: Support address range reclaim
Message-Id: <20130521173332.637942da.akpm@linux-foundation.org>
In-Reply-To: <1368084089-24576-7-git-send-email-minchan@kernel.org>
References: <1368084089-24576-1-git-send-email-minchan@kernel.org>
	<1368084089-24576-7-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:21:28 +0900 Minchan Kim <minchan@kernel.org> wrote:

> This patch adds address range reclaim of a process.
> The requirement is following as,
> 
> Like webkit1, it uses a address space for handling multi tabs.
> IOW, it uses *one* process model so all tabs shares address space
> of the process. In such scenario, per-process reclaim is rather
> coarse-grained so this patch supports more fine-grained reclaim
> for being able to reclaim target address range of the process.
> For reclaim target range, you should use following format.
> 
> 	echo [addr] [size-byte] > /proc/pid/reclaim
> 
> The addr should be page-aligned.
> 
> So now reclaim konb's interface is following as.
> 
> echo file > /proc/pid/reclaim
> 	reclaim file-backed pages only
> 
> echo anon > /proc/pid/reclaim
> 	reclaim anonymous pages only
> 
> echo all > /proc/pid/reclaim
> 	reclaim all pages
> 
> echo 0x100000 8K > /proc/pid/reclaim
> 	reclaim pages in (0x100000 - 0x102000)

This might be going a bit far.  The application itself can be modified
to use fadvise/madvise/whatever to release unused pages and that's a
better interface.

Athough it's a bit of a pipe-dream, I do think we should encourage
userspace to go this path, rather than providing ways for hacky admin
tools to go poking around in /proc/pid/maps and whacking apps
externally.

