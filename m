Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaCGNGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:06:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51186 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaCGNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:06:05 -0500
Date: Fri, 7 Mar 2014 16:05:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
Message-ID: <20140307130556.GN4774@mwanda>
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
 <20140307112655.GJ4774@mwanda>
 <5319B094.7060709@oracle.com>
 <20140307115253.GL4774@mwanda>
 <5319BF21.6080400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5319BF21.6080400@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:44:17PM +0100, Vegard Nossum wrote:
> On 03/07/2014 12:52 PM, Dan Carpenter wrote:
> >On Fri, Mar 07, 2014 at 12:42:12PM +0100, Vegard Nossum wrote:
> >>On 03/07/2014 12:26 PM, Dan Carpenter wrote:
> >>>On Fri, Mar 07, 2014 at 11:56:04AM +0100, Vegard Nossum wrote:
> >>>>Both the in-kernel and BSD strlcpy() require that the source string is
> >>>>NUL terminated.
> >>>
> >>>No.  You're obviously wrong.  What on earth?
> >>
> >>Well, from lib/string.c:
> >>
> >>size_t strlcpy(char *dest, const char *src, size_t size)
> >>{
> >>         size_t ret = strlen(src);
> >>
> >
> >Ah...  So you mean that we could read far beyond the end of the string
> >and it would be a DoS because there would be 4 gigs of memory before we
> >hit a NUL character.  That won't happen in this case because the user
> >only controls a small buffer.  Normal memory is full of NUL chars.
> 
> Well, that's true, but what happens if you accidentally read from an
> unmapped page or an mmio page?

Interesting idea, but "sdef" is on the stack so that doesn't apply here
even though it might apply to other strlcpy() callers.

It might apply to other places.

regards,
dan carpenter

