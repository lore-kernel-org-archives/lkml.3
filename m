Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966311Ab3HHTyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:54:12 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48598 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044Ab3HHTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <1375980460-28311-1-git-send-email-toshi.kani@hp.com>
References: <1375980460-28311-1-git-send-email-toshi.kani@hp.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 8 Aug 2013 15:53:48 -0400
Message-ID: <CAHGf_=qPnmpqxeQ1TkXxapRFvdLbLhC53qS3kNATurhoxKd2PQ@mail.gmail.com>
Subject: Re: [PATCH] mm/hotplug: Verify hotplug memory range
To: Toshi Kani <toshi.kani@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, dave@sr71.net,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "vasilis.liaskovitis" <vasilis.liaskovitis@profitbricks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:47 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> add_memory() and remove_memory() can only handle a memory range aligned
> with section.  There are problems when an unaligned range is added and
> then deleted as follows:
>
>  - add_memory() with an unaligned range succeeds, but __add_pages()
>    called from add_memory() adds a whole section of pages even though
>    a given memory range is less than the section size.
>  - remove_memory() to the added unaligned range hits BUG_ON() in
>    __remove_pages().
>
> This patch changes add_memory() and remove_memory() to check if a given
> memory range is aligned with section at the beginning.  As the result,
> add_memory() fails with -EINVAL when a given range is unaligned, and
> does not add such memory range.  This prevents remove_memory() to be
> called with an unaligned range as well.  Note that remove_memory() has
> to use BUG_ON() since this function cannot fail.
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  mm/memory_hotplug.c |   22 ++++++++++++++++++++++

memory_hotplug.c is maintained by me and kamezawa-san. Please cc us
if you have a subsequent patch.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
