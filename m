Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3IPJQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:16:54 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:59762 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3IPJQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130909164750.GC4701@variantweb.net>
References: <000601ceaac0$5be39f90$13aadeb0$%yang@samsung.com>
	<20130909164750.GC4701@variantweb.net>
Date: Mon, 16 Sep 2013 17:16:52 +0800
Message-ID: <CAL1ERfNmeMCyUGyjTX4_AV41E_iCJicBoz=w16iSOUp+YKYi8A@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm/zswap: use GFP_NOIO instead of GFP_KERNEL
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Weijie Yang <weijie.yang@samsung.com>, minchan@kernel.org,
        bob.liu@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 12:47 AM, Seth Jennings
<sjenning@linux.vnet.ibm.com> wrote:
> On Fri, Sep 06, 2013 at 01:16:45PM +0800, Weijie Yang wrote:
>> To avoid zswap store and reclaim functions called recursively,
>> use GFP_NOIO instead of GFP_KERNEL
>>
>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
>
> I agree with Bob to some degree that GFP_NOIO is a broadsword here.
> Ideally, we'd like to continue allowing writeback of dirty file pages
> and the like.  However, I don't agree that a mutex is the way to do
> this.
>
> My first thought was to use the PF_MEMALLOC task flag, but it is already
> set for kswapd and any task doing direct reclaim.  A new task flag would
> work but I'm not sure how acceptable that would be.

as GFP_NOIO is controversial and not the most appropriate method,
I will keep GFP_KERNEL flag until we find a better way to resolve
this problem.

> In the meantime, this does do away with the possibility of very deep
> recursion between the store and reclaim paths.
>
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>
