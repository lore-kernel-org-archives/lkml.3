Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3IMTtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:49:23 -0400
Received: from science.horizon.com ([71.41.210.146]:63018 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752534Ab3IMTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:49:21 -0400
Date: 13 Sep 2013 15:49:15 -0400
Message-ID: <20130913194915.13780.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: JBeulich@suse.com, joe@perches.com, keescook@chromium.org
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, davem@davemloft.net,
        eldad@fogrefinery.com, linux-kernel@vger.kernel.org, linux@horizon.com,
        rdunlap@infradead.org
In-Reply-To: <5231836102000078000F29AD@nat28.tlf.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why would you want to artificially make the function diverge
> from the spec?

Because %n make it easy to convert a not-uncommon format string bug into
a code injection.  Thus, poses a significant security vulnerability.

Since it's an obscure and  rarely-used feature, it is straightforward
to eliminate all users in the Linux kernel, making removing it possible.

I agree that if it were harmless, it would be useful to leave it
implemented just for simplicity (it's a trivial amount of code), but
it's not harmless.

> People shouldn't be caught by surprises if at all
> possible, and one can certainly not expect people to go look at
> the comment before the function implementation to find out
> what basic (standard) features _do not_ work (one can expect
> so when trying to find out about _extensions_).

This is why people propose implementing it as a kernel warning.

Strongly support this change.
