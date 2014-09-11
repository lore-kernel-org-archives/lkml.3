Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaIKWWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:22:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaIKWWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:22:43 -0400
Date: Thu, 11 Sep 2014 15:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] lib: string: Remove duplicated function
Message-Id: <20140911152241.22ce7f1ebecef7ce7e01b112@linux-foundation.org>
In-Reply-To: <1409124962-11527-2-git-send-email-linux@rasmusvillemoes.dk>
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
	<1409124962-11527-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 09:36:01 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> lib/string.c contains two functions, strnicmp and strncasecmp, which
> do roughly the same thing, namely compare two strings
> case-insensitively up to a given bound. They have slightly different
> implementations, but the only important difference is that strncasecmp
> doesn't handle len==0 appropriately; it effectively becomes strcasecmp
> in that case. strnicmp correctly says that two strings are always
> equal in their first 0 characters.
> 
> strncasecmp is the POSIX name for this functionality. So rename the
> non-broken function to the standard name. To minimize the impact on
> the rest of the kernel (and since both are exported to modules), make
> strnicmp a wrapper for strncasecmp.

I guess it's safe to assume that nobody was depending on the
strncasecmp() bug.

The existing strnicmp() implementation is rather verbose, but I expect
that avoiding the tolower() cost where possible makes sense.

Yes, please prepare the strnicmp()->strncasecmp() patches and let's get
them merged up.  After a kernel release or two we can zap the
back-compat wrapper.


And it isn't just "out of tree modules" that we should be concerned
about - we'll commonly find that "to be in tree" code is using
interfaces which we're trying to alter or remove, so it takes a cycle
or two to get everything propagated.  Most of this code can be found in
linux-next.
