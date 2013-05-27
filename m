Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3E0WZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 18:25:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40534 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3E0WZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 18:25:23 -0400
Message-ID: <1369693520.3301.477.camel@edumazet-glaptop>
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: atomlin@redhat.com, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pshelar@nicira.com, mst@redhat.com,
        alexander.h.duyck@intel.com, aquini@redhat.com,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org
Date: Mon, 27 May 2013 15:25:20 -0700
In-Reply-To: <51A39A3F.8080903@redhat.com>
References: <1369599557-22677-1-git-send-email-atomlin@redhat.com>
	 <51A39A3F.8080903@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 13:39 -0400, Rik van Riel wrote:
> On 05/26/2013 04:19 PM, atomlin@redhat.com wrote:
> > From: Aaron Tomlin <atomlin@redhat.com>
> >
> > Since v1:
> >   - Removed unnecessary parentheses
> >
> > ---8<---
> >
> > Failed GFP_ATOMIC allocations by the network stack result in dropped
> > packets, which will be received on a subsequent retransmit, and an
> > unnecessary, noisy warning with a kernel backtrace.

This claim is wrong, only some protocols deal with retransmits.

> >
> > These warnings are harmless, but they still cause users to panic and
> > file bug reports over dropped packets. It would be better to hide the
> > failed allocation warnings and backtraces, and let retransmits handle
> > dropped packets quietly.
> 
> Yes please. Getting memory management bug reports for
> dropped network packets got old years ago.  Lets get
> rid of those messages.

I am only wondering why this path has anything needing special
attention, over thousands of kmalloc() like call sites in the kernel.

If mm allocation warnings are useless, just make __GFP_NOWARN the
default, and save us thousand of patches (adding the __GFP_NOWARN
everywhere)

Truth is : some network drivers don't deal very well with allocation
errors. mlx4 for example absolutely wants order-2 pages in RX path, with
no fallback to order-0 pages.

So I am not against this patch, but I can not really acknowledge it,
sorry.



