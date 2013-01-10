Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3AJV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 16:58:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3AJV63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 16:58:29 -0500
Date: Thu, 10 Jan 2013 13:58:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm: forcely swapout when we are out of page cache
Message-Id: <20130110135828.c88bcaf1.akpm@linux-foundation.org>
In-Reply-To: <20130110022306.GB14685@blaptop>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
	<1357712474-27595-3-git-send-email-minchan@kernel.org>
	<20130109162602.53a60e77.akpm@linux-foundation.org>
	<20130110022306.GB14685@blaptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013 11:23:06 +0900
Minchan Kim <minchan@kernel.org> wrote:

> > I have a feeling that laptop mode has bitrotted and these patches are
> > kinda hacking around as-yet-not-understood failures...
> 
> Absolutely, this patch is last guard for unexpectable behavior.
> As I mentioned in cover-letter, Luigi's problem could be solved either [1/2]
> or [2/2] but I wanted to add this as last resort in case of unexpected
> emergency. But you're right. It's not good to hide the problem like this path
> so let's drop [2/2].
> 
> Also, I absolutely agree it has bitrotted so for correcting it, we need a
> volunteer who have to inverstigate power saveing experiment with long time.
> So [1/2] would be band-aid until that.

I'm inclined to hold off on 1/2 as well, really.

The point of laptop_mode isn't to save power btw - it is to minimise
the frequency with which the disk drive is spun up.  By deferring and
then batching writeout operations, basically.
