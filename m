Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaBXNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:16:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39333 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaBXNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:16:26 -0500
Date: Mon, 24 Feb 2014 13:16:05 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and
 family
Message-ID: <20140224131605.3bd7febc@alan.etchedpixels.co.uk>
In-Reply-To: <1747419.6FxgzfPen0@wuerfel>
References: <20140224084437.GG20680@thin>
	<201402240902.35977.arnd@arndb.de>
	<10646.1393243751@warthog.procyon.org.uk>
	<1747419.6FxgzfPen0@wuerfel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BUG() normally causes a fault and we print helpful messages before killing
> the task, and gcc knows we never continue because of the
> __builtin_unreachable() annotation.
> 
> If BUG() is defined as 'do { } while (0)' in the example above, we get
> a warning because the function may end without returning a number.
> If we define it to 'do { unreachable(); } while (0)', we don't get a
> warning, but we can get undefined behavior in the case we ever get to
> the end of the function.

That warning is the right thing though. In a lot of cases BUG(); is
followed by code that can lead to serious corruption and potentially
things like disk corruption following or security compromise.

We *should* be warning if you are stupid enough to build a kernel where
BUG() does not terminate.

While I agree defining it as do {} while(1); would be a lot smarter,
simply making it required that a platform provides an implementation of
BUG() would be even better. 

Alan
