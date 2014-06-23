Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaFWVT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:19:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaFWVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:19:27 -0400
Date: Mon, 23 Jun 2014 14:19:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>, Nitin Gupta <ngupta@vflare.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/6] mm/zbud: zbud_alloc() minor param change
Message-Id: <20140623141925.47507153d49f22ee5cca62e1@linux-foundation.org>
In-Reply-To: <1401747586-11861-2-git-send-email-ddstreet@ieee.org>
References: <1400958369-3588-1-git-send-email-ddstreet@ieee.org>
	<1401747586-11861-1-git-send-email-ddstreet@ieee.org>
	<1401747586-11861-2-git-send-email-ddstreet@ieee.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 18:19:41 -0400 Dan Streetman <ddstreet@ieee.org> wrote:

> Change zbud to store gfp_t flags passed at pool creation to use for
> each alloc; this allows the api to be closer to the existing zsmalloc
> interface, and the only current zbud user (zswap) uses the same gfp
> flags for all allocs.  Update zswap to use changed interface.

This would appear to be a step backwards.  There's nothing wrong with
requiring all callers to pass in a gfp_t and removing this option makes
the API less usable.

IMO the patch needs much better justification, or dropping.
