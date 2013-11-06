Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3KFNqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:46:22 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:32893 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3KFNqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:46:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131028221620.042323B3@viggo.jf.intel.com>
References: <20131028221618.4078637F@viggo.jf.intel.com>
	<20131028221620.042323B3@viggo.jf.intel.com>
Date: Wed, 6 Nov 2013 21:46:20 +0800
Message-ID: <CAJd=RBAFgn=3GvEEdHDARpw_h+6SbYE_35D5QJX7C60cVd4tmA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: thp: give transparent hugepage code a separate copy_page
From: Hillf Danton <dhillf@gmail.com>
To: Dave Hansen <dave@sr71.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        dave.jiang@intel.com, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 6:16 AM, Dave Hansen <dave@sr71.net> wrote:
> +
> +void copy_high_order_page(struct page *newpage,
> +                         struct page *oldpage,
> +                         int order)
> +{
> +       int i;
> +
> +       might_sleep();
> +       for (i = 0; i < (1<<order); i++) {
> +               cond_resched();
> +               copy_highpage(newpage + i, oldpage + i);
> +       }
> +}

Can we make no  use of might_sleep here with cond_resched in loop?
