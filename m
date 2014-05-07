Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaEGIzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:55:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36700 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaEGIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:55:40 -0400
Date: Wed, 7 May 2014 11:55:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, devel@driverdev.osuosl.org,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        linuxgeek@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8712: fix potential leak in
 r871x_wx_set_enc_ext()
Message-ID: <20140507085516.GY26890@mwanda>
References: <20140501114500.756b95d0@spike>
 <1399445747.2677.4.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399445747.2677.4.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:55:47AM +0300, Andy Shevchenko wrote:
> > @@ -1824,6 +1817,15 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
> >  	default:
> >  		return -EINVAL;
> >  	}
> > +
> > +	param_len = sizeof(struct ieee_param) + pext->key_len;
> > +	param = (struct ieee_param *)_malloc(param_len);
> 
> While you are here could you substitute _malloc by kzalloc and remove
> explicit casting and memset?
> 

Normally, that's the kind of thing we would do in a separate patch
because or the "one thing per patch" rule.  Eventually someone will do a
driver wide replacement of _malloc().  Or if the bug fixer wanted, he
could do it in this patch because it is on the same line and all so it
counts as a "minor closely related change."  Either way is fine.

Another way to say this is that since the _malloc() was there in the
original code and Christian didn't introduce it, then we shouldn't
reject his patch because of it.  This is staging code, and there are so
many problems that if you start trying to fix everything you'll just get
lost.

In my experience v2 patches are much harder to write than v1 patches.
Twice in the past few days I have messed up the subject line in my v2
patches.

regards,
dan carpenter

