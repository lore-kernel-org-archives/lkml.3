Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3DQPT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:19:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3DQPT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:19:58 -0400
Date: Wed, 17 Apr 2013 16:08:37 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swap: redirty page if page write fails on swap file
Message-ID: <20130417150837.GB1852@suse.de>
References: <516E918B.3050309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <516E918B.3050309@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 02:11:55PM +0200, Jerome Marchand wrote:
> 
> Since commit 62c230b, swap_writepage() calls direct_IO on swap files.
> However, in that case page isn't redirtied if I/O fails, and is therefore
> handled afterwards as if it has been successfully written to the swap
> file, leading to memory corruption when the page is eventually swapped
> back in.
> This patch sets the page dirty when direct_IO() fails. It fixes a memory
> corruption that happened while using swap-over-NFS.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

Thanks Jerome. I've added Andrew to the cc and this should also be
considered a candidate for 3.8-stable.

-- 
Mel Gorman
SUSE Labs
