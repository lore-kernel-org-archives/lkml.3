Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaFWVsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:48:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaFWVse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:48:34 -0400
Date: Mon, 23 Jun 2014 14:48:31 -0700
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
Subject: Re: [PATCHv2 6/6] mm/zpool: prevent zbud/zsmalloc from unloading
 when used
Message-Id: <20140623144831.83abcda7446956e8d7502f09@linux-foundation.org>
In-Reply-To: <1401747586-11861-7-git-send-email-ddstreet@ieee.org>
References: <1400958369-3588-1-git-send-email-ddstreet@ieee.org>
	<1401747586-11861-1-git-send-email-ddstreet@ieee.org>
	<1401747586-11861-7-git-send-email-ddstreet@ieee.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 18:19:46 -0400 Dan Streetman <ddstreet@ieee.org> wrote:

> Add try_module_get() to zpool_create_pool(), and module_put() to
> zpool_destroy_pool().  Without module usage counting, the driver module(s)
> could be unloaded while their pool(s) were active, resulting in an oops
> when zpool tried to access them.

Was wondering about that ;)  We may as well fold
this fix into "mm/zpool: implement common zpool api to zbud/zsmalloc"?
