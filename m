Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaEGVPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:15:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEGVPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:15:36 -0400
Date: Wed, 7 May 2014 14:15:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 2/6] mm, compaction: return failed migration target
 pages back to freelist
Message-Id: <20140507141534.d4def933b3a9999e7826df5c@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1405061921040.18635@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1405061921040.18635@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 19:22:43 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Memory compaction works by having a "freeing scanner" scan from one end of a 
> zone which isolates pages as migration targets while another "migrating scanner" 
> scans from the other end of the same zone which isolates pages for migration.
> 
> When page migration fails for an isolated page, the target page is returned to 
> the system rather than the freelist built by the freeing scanner.  This may 
> require the freeing scanner to continue scanning memory after suitable migration 
> targets have already been returned to the system needlessly.
> 
> This patch returns destination pages to the freeing scanner freelist when page 
> migration fails.  This prevents unnecessary work done by the freeing scanner but 
> also encourages memory to be as compacted as possible at the end of the zone.
> 
> Reported-by: Greg Thelen <gthelen@google.com>

What did Greg actually report?  IOW, what if any observable problem is
being fixed here?
