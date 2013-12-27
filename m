Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3L0Mcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 07:32:54 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:36738 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3L0Mcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 07:32:53 -0500
Date: Fri, 27 Dec 2013 05:32:50 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Benjamin <bcrl@kvack.org>, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aio: optimize free kioctx slot search
Message-ID: <20131227123250.GA22587@parisc-linux.org>
References: <52BC0352.2040504@cn.fujitsu.com> <20131226141356.GH11091@parisc-linux.org> <52BD5738.4010308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BD5738.4010308@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 06:32:24PM +0800, Gu Zheng wrote:
> Hi Matthew,
> On 12/26/2013 10:13 PM, Matthew Wilcox wrote:
> 
> > On Thu, Dec 26, 2013 at 06:22:10PM +0800, Gu Zheng wrote:
> >> to the new free slot if it's smaller than 'next_free'. So that we can
> >> ensure that the slots before 'next_free' are all used, and the search can start
> >> from 'next_free' to reduce the search and improve the performance.
> > 
> > Have you benchmarked it?  What kinds of improvements are you seeing?
> 
> Not yet. But the improvement is obvious, we can always reduce the search region and
> improve the hit rate when trying to find a free slot with this change.

It's not so obvious to me.  You've added extra stores, which may dirty
an additional cacheline.  That may end up costing more than it saves.
I suspect the difference is lost in the noise, but I've been wrong about
these things before.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
