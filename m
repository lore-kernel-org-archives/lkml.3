Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3DAUOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:14:06 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:14876 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696Ab3DAUOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:14:03 -0400
Date: Mon, 1 Apr 2013 20:14:01 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ilia Mirkin <imirkin@alum.mit.edu>
cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: system death under oom - 3.7.9
In-Reply-To: <CAKb7UviwOk9asT=WxYgDUzfm3J+tGXobroUycpoTvzOX5kkofQ@mail.gmail.com>
Message-ID: <0000013dc73c284d-29fd15db-416b-40cc-81b6-81abc5bd3c02-000000@email.amazonses.com>
References: <CAKb7UviwOk9asT=WxYgDUzfm3J+tGXobroUycpoTvzOX5kkofQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Ilia Mirkin wrote:

> The GPF happens at +160, which is in the argument setup for the
> cmpxchg in slab_alloc_node. I think it's the call to
> get_freepointer(). There was a similar bug report a while back,
> https://lkml.org/lkml/2011/5/23/199, and the recommendation was to run
> with slub debugging. Is that still the case, or is there a simpler
> explanation? I can't reproduce this at will, not sure how many times
> this has happened but definitely not many.

slub debugging will help to track down the cause of the memory corruption.
