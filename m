Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaA3Vos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:44:48 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39580 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaA3Vor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:44:47 -0500
Date: Thu, 30 Jan 2014 13:44:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Joe Perches <joe@perches.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v5 1/2] mm: add kstrimdup function
In-Reply-To: <20140130132251.4f662aeddc09d8410dee4490@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401301343430.15271@chino.kir.corp.google.com>
References: <1391116318-17253-1-git-send-email-sebastian.capella@linaro.org> <1391116318-17253-2-git-send-email-sebastian.capella@linaro.org> <20140130132251.4f662aeddc09d8410dee4490@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Andrew Morton wrote:

> > @@ -63,6 +64,35 @@ char *kstrndup(const char *s, size_t max, gfp_t gfp)
> >  EXPORT_SYMBOL(kstrndup);
> >  
> >  /**
> > + * kstrimdup - Trim and copy a %NUL terminated string.
> > + * @s: the string to trim and duplicate
> > + * @gfp: the GFP mask used in the kmalloc() call when allocating memory
> > + *
> > + * Returns an address, which the caller must kfree, containing
> > + * a duplicate of the passed string with leading and/or trailing
> > + * whitespace (as defined by isspace) removed.
> > + */
> > +char *kstrimdup(const char *s, gfp_t gfp)
> > +{
> > +	char *buf;
> > +	char *begin = skip_spaces(s);
> > +	size_t len = strlen(begin);
> > +
> > +	while (len > 1 && isspace(begin[len - 1]))
> > +		len--;
> 
> That's off-by-one isn't it?  kstrimdup("   ") should return "", not " ".
> 

Yeah, this is an incorrect copy-and-paste of Joe Perches' suggested code 
from http://marc.info/?l=linux-kernel&m=139104508317989.
