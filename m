Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaCGLxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:53:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21994 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaCGLxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:53:02 -0500
Date: Fri, 7 Mar 2014 14:52:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
Message-ID: <20140307115253.GL4774@mwanda>
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
 <20140307112655.GJ4774@mwanda>
 <5319B094.7060709@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5319B094.7060709@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 12:42:12PM +0100, Vegard Nossum wrote:
> On 03/07/2014 12:26 PM, Dan Carpenter wrote:
> >On Fri, Mar 07, 2014 at 11:56:04AM +0100, Vegard Nossum wrote:
> >>Both the in-kernel and BSD strlcpy() require that the source string is
> >>NUL terminated.
> >
> >No.  You're obviously wrong.  What on earth?
> 
> Well, from lib/string.c:
> 
> size_t strlcpy(char *dest, const char *src, size_t size)
> {
>         size_t ret = strlen(src);
>

Ah...  So you mean that we could read far beyond the end of the string
and it would be a DoS because there would be 4 gigs of memory before we
hit a NUL character.  That won't happen in this case because the user
only controls a small buffer.  Normal memory is full of NUL chars.

I don't know the speed impact of changing the strlen() there to
strnlen().

> The BSD man page:
> 
> "Also note that strlcpy() and strlcat() only operate on true ``C''
> strings.  This means that for strlcpy() src must be NUL-terminated
> and for strlcat() both src and dst must be NUL-terminated."

It's talking about the kind of strings.  If it's a string which includes
NUL characters the strlcpy() won't work for that.  Or if it is not
*supposed* to end in a NUL character then it won't work for that.

We are using C strings here.

regards,
dan carpenter

