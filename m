Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaINXYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 19:24:20 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55522 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaINXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 19:24:19 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 15 Sep 2014 08:24:27 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Linux-MM <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/10] zsmalloc: fix init_zspage free obj linking
Message-ID: <20140914232427.GD2160@bbox>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
 <1410468841-320-2-git-send-email-ddstreet@ieee.org>
 <20140912045913.GA2160@bbox>
 <CALZtONAuJhgZLJECxwQOyKPj2n02d+521d+eHCkqLjjc=Ba9FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALZtONAuJhgZLJECxwQOyKPj2n02d+521d+eHCkqLjjc=Ba9FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:43:22PM -0400, Dan Streetman wrote:
> On Fri, Sep 12, 2014 at 12:59 AM, Minchan Kim <minchan@kernel.org> wrote:
> > On Thu, Sep 11, 2014 at 04:53:52PM -0400, Dan Streetman wrote:
> >> When zsmalloc creates a new zspage, it initializes each object it contains
> >> with a link to the next object, so that the zspage has a singly-linked list
> >> of its free objects.  However, the logic that sets up the links is wrong,
> >> and in the case of objects that are precisely aligned with the page boundries
> >> (e.g. a zspage with objects that are 1/2 PAGE_SIZE) the first object on the
> >> next page is skipped, due to incrementing the offset twice.  The logic can be
> >> simplified, as it doesn't need to calculate how many objects can fit on the
> >> current page; simply checking the offset for each object is enough.
> >
> > If objects are precisely aligned with the page boundary, pages_per_zspage
> > should be 1 so there is no next page.
> 
> ah, ok.  I wonder if it should be changed anyway so it doesn't rely on
> that detail, in case that's ever changed in the future.  It's not
> obvious the existing logic relies on that for correct operation.  And
> this simplifies the logic too.

Correct description and resend if you want.

-- 
Kind regards,
Minchan Kim
