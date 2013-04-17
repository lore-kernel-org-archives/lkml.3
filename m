Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966688Ab3DQPIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:08:09 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43261 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966461Ab3DQPII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:08:08 -0400
Date: Wed, 17 Apr 2013 08:07:57 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] swap: redirty page if page write fails on swap file
Message-ID: <20130417150757.GA21444@cmpxchg.org>
References: <516E918B.3050309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516E918B.3050309@redhat.com>
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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
