Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3G2XrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:47:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3G2XrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:47:00 -0400
Date: Mon, 29 Jul 2013 16:46:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Vineet.Gupta1@synopsys.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hughd@google.com,
        riel@redhat.com, rientjes@google.com, peterz@infradead.org,
        linux-arch@vger.kernel.org, catalin.marinas@arm.com,
        jcmvbkbc@gmail.com, Greg KH <greg@kroah.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Fix the TLB range flushed when __tlb_remove_page()
 runs out of slots
Message-Id: <20130729164658.0dfa1ff602bc131fe2ec0b1b@linux-foundation.org>
In-Reply-To: <20130729.164106.943996066712571180.davem@davemloft.net>
References: <1369832173-15088-1-git-send-email-vgupta@synopsys.com>
	<20130729.164106.943996066712571180.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 16:41:06 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Date: Wed, 29 May 2013 18:26:13 +0530
> 
> > zap_pte_range loops from @addr to @end. In the middle, if it runs out of
> > batching slots, TLB entries needs to be flushed for @start to @interim,
> > NOT @interim to @end.
> > 
> > Since ARC port doesn't use page free batching I can't test it myself but
> > this seems like the right thing to do.
> > Observed this when working on a fix for the issue at thread:
> > 	http://www.spinics.net/lists/linux-arch/msg21736.html
> > 
> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> 
> As this bug can cause pretty serious memory corruption, I'd like to
> see this submitted to -stable.

Greg, e6c495a96ce02574e765d5140039a64c8d4e8c9e from mainline, please.
