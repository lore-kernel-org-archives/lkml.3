Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3A1Vuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:50:50 -0500
Received: from mail-ye0-f171.google.com ([209.85.213.171]:42597 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3A1Vur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:50:47 -0500
Date: Mon, 28 Jan 2013 13:50:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128215042.GN22465@mtj.dyndns.org>
References: <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
 <20130128214506.GG26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128214506.GG26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Mon, Jan 28, 2013 at 01:45:06PM -0800, Kent Overstreet wrote:
> Ahh. Bias value sounds... hacky (i.e. harder to convince myself it's
> correct) but I see what you're getting at.

I don't think it's that hacky.  Just push the base point to the
opposite of zero - LLONG_MAX.  The global counter can start biased so
that it gets unbiased only once dying is confirmed and everything can
blindly do atomic64_dec_and_test() and trust the result.

> Something to consider is wrapping; after we set state to dying but
> before we've collected the percpu counters, the atomic counter may be
> negative.

There's a reason why we use 64bit vars for this type of global
counting.  They virtually don't wrap.  Here, you'll need 1<<63 for the
counter to unintentionally reach 0, which we consider practically
impossible.

Thanks.

-- 
tejun
