Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaIERuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:50:44 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35176 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaIERun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:50:43 -0400
Date: Fri, 5 Sep 2014 21:50:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] kcmp: Fix standard comparison bug
Message-ID: <20140905175040.GR16395@moon>
References: <1409827206-4199-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409827206-4199-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 12:40:06PM +0200, Rasmus Villemoes wrote:
> The C operator <= defines a perfectly fine total ordering on the set
> of values representable in a long. However, unlike its namesake in the
> integers, it is not translation invariant, meaning that we do not have
> "b <= c" iff "a+b <= a+c" for all a,b,c.
> 
> This means that it is always wrong to try to boil down the
> relationship between two longs to a question about the sign of their
> difference, because the resulting relation [a LEQ b iff a-b <= 0] is
> neither anti-symmetric or transitive. The former is due to
> -LONG_MIN==LONG_MIN (take any two a,b with a-b = LONG_MIN; then a LEQ
> b and b LEQ a, but a != b). The latter can either be seen observing
> that x LEQ x+1 for all x, implying x LEQ x+1 LEQ x+2 ... LEQ x-1 LEQ
> x; or more directly with the simple example a=LONG_MIN, b=0, c=1, for
> which a-b < 0, b-c < 0, but a-c > 0.
> 
> Note that it makes absolutely no difference that a transmogrying
> bijection has been applied before the comparison is done. In fact, had
> the obfuscation not been done, one could probably not observe the bug
> (assuming all values being compared always lie in one half of the
> address space, the mathematical value of a-b is always representable
> in a long). As it stands, one can easily obtain three file descriptors
> exhibiting the non-transitivity of kcmp().
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Just noted that Andrew's email address has been screwed for some reason,
fixed. Guys, pick it up please, and many thanks to Rasmus for finding it.
