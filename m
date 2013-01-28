Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3A1Do5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:44:57 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54689 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3A1Doz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:44:55 -0500
Date: Sun, 27 Jan 2013 19:44:56 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/11] ksm: make KSM page migration possible
In-Reply-To: <1359333683.6763.13.camel@kernel>
Message-ID: <alpine.LNX.2.00.1301271936071.896@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251802050.29196@eggly.anvils> <1359265635.6763.0.camel@kernel> <alpine.LNX.2.00.1301271506480.17495@eggly.anvils> <1359333683.6763.13.camel@kernel>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013, Simon Jeons wrote:
> On Sun, 2013-01-27 at 15:12 -0800, Hugh Dickins wrote:
> > On Sat, 26 Jan 2013, Simon Jeons wrote:
> > > 
> > > Could you explain why need check page->mapping twice after get page?
> > 
> > Once for the !locked case, which should not return page if mapping changed.
> > Once for the locked case, which should not return page if mapping changed.
> > We could use "else", but that wouldn't be an improvement.
> 
> But for locked case, page->mapping will be check twice.

Thrice.

I'm beginning to wonder: you do realize that page->mapping is volatile,
from the point of view of get_ksm_page()?  That is the whole point of
why get_ksm_page() exists.

I can see that the word "volatile" is not obviously used here - it's
tucked away inside the ACCESS_ONCE() - but I thought the descriptions
of races and barriers made that obvious.

If the comments here haven't helped enough, please take a look at
git commit 4035c07a8959 "ksm: take keyhole reference to page".
