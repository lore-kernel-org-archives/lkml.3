Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab3HNU0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:26:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab3HNU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:26:04 -0400
Date: Wed, 14 Aug 2013 13:26:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Xishi Qiu <qiuxishi@huawei.com>,
        riel@redhat.com, aquini@redhat.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
Message-Id: <20130814132602.814a88e991e29c5b93bbe22c@linux-foundation.org>
In-Reply-To: <20130814155205.GA2706@gmail.com>
References: <520B0B75.4030708@huawei.com>
	<20130814085711.GK2296@suse.de>
	<20130814155205.GA2706@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 00:52:29 +0900 Minchan Kim <minchan@kernel.org> wrote:

> On Wed, Aug 14, 2013 at 09:57:11AM +0100, Mel Gorman wrote:
> > On Wed, Aug 14, 2013 at 12:45:41PM +0800, Xishi Qiu wrote:
> > > A large free page buddy block will continue many times, so if the page 
> > > is free, skip the whole page buddy block instead of one page.
> > > 
> > > Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> > 
> > page_order cannot be used unless zone->lock is held which is not held in
> > this path. Acquiring the lock would prevent parallel allocations from the
> 
> Argh, I missed that.

I missed it as well. And so did Xishi Qiu.

Mel, we have a problem.  What can we do to make this code more
maintainable?
