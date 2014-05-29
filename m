Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaE2TcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:32:22 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60445 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaE2TcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:32:21 -0400
Date: Thu, 29 May 2014 12:32:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] CMA: use MIGRATE_SYNC in alloc_contig_range()
In-Reply-To: <1401344750-3684-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1405291229330.28183@chino.kir.corp.google.com>
References: <1401344750-3684-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Joonsoo Kim wrote:

> Before commit 'mm, compaction: embed migration mode in compact_control'
> from David is merged, alloc_contig_range() used sync migration,
> instead of sync_light migration. This doesn't break anything currently
> because page isolation doesn't have any difference with sync and
> sync_light, but it could in the future, so change back as it was.
> 
> And pass cc->mode to migrate_pages(), instead of passing MIGRATE_SYNC
> to migrate_pages().
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>

Should probably be renamed 
mm-compaction-embed-migration-mode-in-compact_control-fix-fix though since 
it's based on another patch in -mm that properly does the s/sync/mode/ 
conversion for CMA.
