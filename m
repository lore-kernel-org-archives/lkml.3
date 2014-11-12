Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaKLOUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:20:38 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:58909 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaKLOUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:20:37 -0500
Date: Wed, 12 Nov 2014 09:20:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'Rik van Riel'" <riel@redhat.com>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: mincore: add hwpoison page handle
Message-ID: <20141112142022.GA29766@phnom.home.cmpxchg.org>
References: <000001cffe2a$66a95a50$33fc0ef0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cffe2a$66a95a50$33fc0ef0$%yang@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:39:29AM +0800, Weijie Yang wrote:
> When encounter pte is a swap entry, the current code handles two cases:
> migration and normal swapentry, but we have a third case: hwpoison page.
> 
> This patch adds hwpoison page handle, consider hwpoison page incore as
> same as migration.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

The change makes sense:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

But please add a description of what happens when a poison entry is
encountered with the current code.  I'm guessing swap_address_space()
will return garbage and this might crash the kernel?
