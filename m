Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaEPPBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:01:06 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43096 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbaEPPBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:01:04 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/3] lib: add glibc style strchrnul() variant
To: frowand.list@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <53753D54.7040308@gmail.com>
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org>
	<1399993115-21552-2-git-send-email-grant.likely@linaro.org>
	<53753D54.7040308@gmail.com>
Date: Fri, 16 May 2014 16:00:42 +0100
Message-Id: <20140516150042.7F99EC40515@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 15:19:00 -0700, Frank Rowand <frowand.list@gmail.com> wrote:
> On 5/13/2014 7:58 AM, Grant Likely wrote:
> > The strchrnul() variant helpfully returns a the end of the string
> > instead of a NULL if the requested character is not found. This can
> > simplify string parsing code since it doesn't need to expicitly check
> > for a NULL return. If a valid string pointer is passed in, then a valid
> > null terminated string will always come back out.
> > 
> > Signed-off-by: Grant Likely <grant.likely@linaro.org>
> > ---
> >  include/linux/string.h |  3 +++
> >  lib/string.c           | 15 +++++++++++++++
> >  2 files changed, 18 insertions(+)
> > 
> > diff --git a/include/linux/string.h b/include/linux/string.h
> > index ac889c5ea11b..d36977e029af 100644
> > --- a/include/linux/string.h
> > +++ b/include/linux/string.h
> > @@ -52,6 +52,9 @@ extern int strncasecmp(const char *s1, const char *s2, size_t n);
> >  #ifndef __HAVE_ARCH_STRCHR
> >  extern char * strchr(const char *,int);
> >  #endif
> > +#ifndef __HAVE_ARCH_STRCHRNUL
> > +extern char * strchrnul(const char *,int);
> > +#endif
> >  #ifndef __HAVE_ARCH_STRNCHR
> >  extern char * strnchr(const char *, size_t, int);
> >  #endif
> > diff --git a/lib/string.c b/lib/string.c
> > index 9b1f9062a202..059636f92c26 100644
> > --- a/lib/string.c
> > +++ b/lib/string.c
> > @@ -301,6 +301,21 @@ char *strchr(const char *s, int c)
> >  EXPORT_SYMBOL(strchr);
> >  #endif
> >  
> > +#ifndef __HAVE_ARCH_STRCHRNUL
> > +/**
> > + * strchr - Find the first occurrence of a character in a string
> 
> s/strchr/strchrnul/
> 
> Add to the end of the description: if c is not found in s then return
> a pointer to the null byte at the end of s

Thanks, fixed.

> 
> > + * @s: The string to be searched
> > + * @c: The character to search for
> > + */
> > +char *strchrnul(const char *s, int c)
> > +{
> > +	while (*s && *s != (char)c)
> > +		s++;
> > +	return (char *)s;
> > +}
> > +EXPORT_SYMBOL(strchrnul);
> > +#endif
> > +
> >  #ifndef __HAVE_ARCH_STRRCHR
> >  /**
> >   * strrchr - Find the last occurrence of a character in a string
> > 
> 

