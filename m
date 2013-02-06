Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3BFByX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:54:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3BFByU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:54:20 -0500
Date: Tue, 5 Feb 2013 17:58:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Linux MM <linux-mm@kvack.org>, mgorman@suse.de, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: rename confusing function names
Message-Id: <20130205175802.2c62c826.akpm@linux-foundation.org>
In-Reply-To: <5111B318.9020204@cn.fujitsu.com>
References: <51113CE3.5090000@gmail.com>
	<20130205192640.GC6481@cmpxchg.org>
	<20130205141332.04fcceac.akpm@linux-foundation.org>
	<5111AC7D.9070505@cn.fujitsu.com>
	<20130205172057.3be4dbd4.akpm@linux-foundation.org>
	<5111B318.9020204@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2013 09:34:16 +0800 Zhang Yanfei <zhangyanfei@cn.fujitsu.com> wrote:

> > 
> > 
> > hm,
> > 
> > static unsigned int nr_free_zone_pages(int offset)
> > {
> > 	...
> > 	unsigned int sum = 0;
> > 	...
> > 	return sum;
> > }
> > 
> > How long will it be until these things start exploding from
> > sums-of-zones which exceed 16TB?  
> > 
> 
> You mean overflow? Hmm.. it might happens. Change the sum to
> unsigned long is ok?

The sum, the return value.  And in the case of nr_free_buffer_pages(),
the signedness of the return value (sheesh).  Then review and if
necessary fix up all the callsites.  That's all a separate exercise.

