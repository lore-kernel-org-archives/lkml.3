Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3IIQr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:47:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49182 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3IIQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:47:57 -0400
Date: Mon, 9 Sep 2013 11:47:50 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm/zswap: use GFP_NOIO instead of GFP_KERNEL
Message-ID: <20130909164750.GC4701@variantweb.net>
References: <000601ceaac0$5be39f90$13aadeb0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601ceaac0$5be39f90$13aadeb0$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090916-9332-0000-0000-0000015B2C30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 01:16:45PM +0800, Weijie Yang wrote:
> To avoid zswap store and reclaim functions called recursively,
> use GFP_NOIO instead of GFP_KERNEL
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

I agree with Bob to some degree that GFP_NOIO is a broadsword here.
Ideally, we'd like to continue allowing writeback of dirty file pages
and the like.  However, I don't agree that a mutex is the way to do
this.

My first thought was to use the PF_MEMALLOC task flag, but it is already
set for kswapd and any task doing direct reclaim.  A new task flag would
work but I'm not sure how acceptable that would be.

In the meantime, this does do away with the possibility of very deep
recursion between the store and reclaim paths.

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

