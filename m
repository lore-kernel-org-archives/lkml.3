Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3EZLpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 07:45:20 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35885 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3EZLpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 07:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <537407790857e8a5d4db5fb294a909a61be29687.1369529143.git.aquini@redhat.com>
References: <cover.1369529143.git.aquini@redhat.com> <537407790857e8a5d4db5fb294a909a61be29687.1369529143.git.aquini@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 26 May 2013 07:44:56 -0400
Message-ID: <CAHGf_=qU5nBeya=God5AyG2szvtJJCDd4VOt0TJZBgiEX27Njw@mail.gmail.com>
Subject: Re: [PATCH 01/02] swap: discard while swapping only if SWAP_FLAG_DISCARD_PAGES
To: Rafael Aquini <aquini@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, shli@kernel.org, kzak@redhat.com,
        Jeff Moyer <jmoyer@redhat.com>, "riel@redhat.com" <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +                       /*
> +                        * By flagging sys_swapon, a sysadmin can tell us to
> +                        * either do sinle-time area discards only, or to just
> +                        * perform discards for released swap page-clusters.
> +                        * Now it's time to adjust the p->flags accordingly.
> +                        */
> +                       if (swap_flags & SWAP_FLAG_DISCARD_ONCE)
> +                               p->flags &= ~SWP_PAGE_DISCARD;
> +                       else if (swap_flags & SWAP_FLAG_DISCARD_PAGES)
> +                               p->flags &= ~SWP_AREA_DISCARD;

When using old swapon(8), this code turn off both flags, right?
