Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3DXIST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:18:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58431 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab3DXISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:18:17 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-5c-5177954693e7
Date: Wed, 24 Apr 2013 17:18:14 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2 6/6] add documentation on proc.txt
Message-ID: <20130424081814.GC2978@blaptop>
References: <1366767664-17541-1-git-send-email-minchan@kernel.org>
 <1366767664-17541-7-git-send-email-minchan@kernel.org>
 <1366786185.18069.160@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366786185.18069.160@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rob,

On Wed, Apr 24, 2013 at 01:49:45AM -0500, Rob Landley wrote:
> On 04/23/2013 08:41:04 PM, Minchan Kim wrote:
> >This patch adds stuff about new reclaim field in proc.txt
> >
> >Cc: Rob Landley <rob@landley.net>
> >Signed-off-by: Minchan Kim <minchan@kernel.org>
> >---
> >
> >Rob, I didn't add your Acked-by because interface was slight changed.
> >I hope you give Acke-by after review again.
> >Thanks.
> >
> > Documentation/filesystems/proc.txt | 22 ++++++++++++++++++++++
> > mm/Kconfig                         |  7 +------
> > 2 files changed, 23 insertions(+), 6 deletions(-)
> >
> >diff --git a/Documentation/filesystems/proc.txt
> >b/Documentation/filesystems/proc.txt
> >index 488c094..1411ad0 100644
> >--- a/Documentation/filesystems/proc.txt
> >+++ b/Documentation/filesystems/proc.txt
> >@@ -136,6 +136,7 @@ Table 1-1: Process specific entries in /proc
> >  maps		Memory maps to executables and library files	(2.4)
> >  mem		Memory held by this process
> >  root		Link to the root directory of this process
> >+ reclaim	Reclaim pages in this process
> >  stat		Process status
> >  statm		Process memory status information
> >  status		Process status in human readable form
> >@@ -489,6 +490,27 @@ To clear the soft-dirty bit
> >
> > Any other value written to /proc/PID/clear_refs will have no effect.
> >
> >+The file /proc/PID/reclaim is used to reclaim pages in this process.
> >+To reclaim file-backed pages,
> >+    > echo file > /proc/PID/reclaim
> >+
> >+To reclaim anonymous pages,
> >+    > echo anon > /proc/PID/reclaim
> >+
> >+To reclaim all pages,
> >+    > echo all > /proc/PID/reclaim
> >+
> >+Also, you can specify address range of process so part of address
> >space
> >+will be reclaimed. The format is following as
> >+    > echo addr size-byte > /proc/PID/reclaim
> >+
> >+NOTE: addr should be page-aligned.
> 
> And size in bytes should be a multiple of page size?

Not necessary. It's same with madvise that VM handle the page
which includes the byte.

> 
> >+
> >+Below is example which try to reclaim 2 pages from 0x100000.
> >+
> >+To reclaim both pages in address range,
> >+    > echo $((1<<20) 8192 > /proc/PID/reclaim
> 
> Would you like to balance your parentheses?

Fixed. I will include your Acked-by in next spin.
Thanks!

> 
> Acked-by: Rob Landley <rob@landley.net>
> 
> Rob

-- 
Kind regards,
Minchan Kim
