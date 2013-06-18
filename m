Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3FRQZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:25:37 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47136 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3FRQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:25:10 -0400
MIME-Version: 1.0
In-Reply-To: <1371154622-8929-2-git-send-email-yinghai@kernel.org>
References: <1371154622-8929-1-git-send-email-yinghai@kernel.org>
	<1371154622-8929-2-git-send-email-yinghai@kernel.org>
Date: Tue, 18 Jun 2013 12:25:09 -0400
Message-ID: <CA+5PVA4by9=gaXz7nuiQE4RT4LKvDzYUDS__uNx0KXmLWHDJFw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] x86, mtrr: Fix original mtrr range get for mtrr_cleanup
From: Josh Boyer <jwboyer@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 4:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Joshua reported: Commit cd7b304dfaf1 (x86, range: fix missing merge
> during add range) broke mtrr cleanup on his setup in 3.9.5.
> corresponding commit in upstream is fbe06b7bae7c.
>
>   *BAD*gran_size: 64K chunk_size: 16M num_reg: 6 lose cover RAM: -0G
>
> https://bugzilla.kernel.org/show_bug.cgi?id=59491
>
> So it rejects new var mtrr layout.
>
> It turns out we have some problem with initial mtrr range retrievel.
> current sequence is:
>         x86_get_mtrr_mem_range
>                 ==> bunchs of add_range_with_merge
>                 ==> bunchs of subract_range
>                 ==> clean_sort_range
>         add_range_with_merge for [0,1M)
>         sort_range()
>
> add_range_with_merge could have blank slots, so we can not just
> sort only, that will have final result have extra blank slot in head.
>
> So move that calling add_range_with_merge for [0,1M), with that we
> could avoid extra clean_sort_range calling.
>
> Reported-by: Joshua Covington <joshuacov@googlemail.com>
> Tested-by: Joshua Covington <joshuacov@googlemail.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: <stable@vger.kernel.org> v3.9

We're at -rc6 now and this and it's companion aren't in Linus' tree,
which means the broken 3.9.y stable series doesn't have them either.
It's been posted for a while now, and v3 was really a minor cleanup.
Is there some reason this is still not merged?  We've been carrying v2
in Fedora for a bit now and it's cleared up the issue for a number of
people.

josh
