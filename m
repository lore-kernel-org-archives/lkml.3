Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab3G3AQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:16:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43785 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab3G3AQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:16:13 -0400
X-Sasl-enc: 2DXH1vcRbfdFbzhe4dzTdJ6rBhzcUCp5XUxgYXc1DO83 1375143372
Date: Mon, 29 Jul 2013 17:16:11 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Vineet.Gupta1@synopsys.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        hughd@google.com, riel@redhat.com, rientjes@google.com,
        peterz@infradead.org, linux-arch@vger.kernel.org,
        catalin.marinas@arm.com, jcmvbkbc@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Fix the TLB range flushed when __tlb_remove_page()
 runs out of slots
Message-ID: <20130730001611.GA15007@kroah.com>
References: <1369832173-15088-1-git-send-email-vgupta@synopsys.com>
 <20130729.164106.943996066712571180.davem@davemloft.net>
 <20130729164658.0dfa1ff602bc131fe2ec0b1b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729164658.0dfa1ff602bc131fe2ec0b1b@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 04:46:58PM -0700, Andrew Morton wrote:
> On Mon, 29 Jul 2013 16:41:06 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> 
> > From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> > Date: Wed, 29 May 2013 18:26:13 +0530
> > 
> > > zap_pte_range loops from @addr to @end. In the middle, if it runs out of
> > > batching slots, TLB entries needs to be flushed for @start to @interim,
> > > NOT @interim to @end.
> > > 
> > > Since ARC port doesn't use page free batching I can't test it myself but
> > > this seems like the right thing to do.
> > > Observed this when working on a fix for the issue at thread:
> > > 	http://www.spinics.net/lists/linux-arch/msg21736.html
> > > 
> > > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> > 
> > As this bug can cause pretty serious memory corruption, I'd like to
> > see this submitted to -stable.
> 
> Greg, e6c495a96ce02574e765d5140039a64c8d4e8c9e from mainline, please.

Now applied to 3.10-stable, thanks.

greg k-h
