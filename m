Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbaEMJB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:01:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:60079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbaEMJBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:01:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="510782412"
Message-ID: <1399971676.3703.21.camel@smile.fi.intel.com>
Subject: Re: [PATCH] staging: rtl8712: fix potential leak in
 r871x_wx_set_enc_ext()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, devel@driverdev.osuosl.org,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        linuxgeek@gmail.com, Larry.Finger@lwfinger.net
Date: Tue, 13 May 2014 12:01:16 +0300
In-Reply-To: <20140507085516.GY26890@mwanda>
References: <20140501114500.756b95d0@spike>
	 <1399445747.2677.4.camel@smile.fi.intel.com>
	 <20140507085516.GY26890@mwanda>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-05-07 at 11:55 +0300, Dan Carpenter wrote:
> On Wed, May 07, 2014 at 09:55:47AM +0300, Andy Shevchenko wrote:
> > > @@ -1824,6 +1817,15 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
> > >  	default:
> > >  		return -EINVAL;
> > >  	}
> > > +
> > > +	param_len = sizeof(struct ieee_param) + pext->key_len;
> > > +	param = (struct ieee_param *)_malloc(param_len);
> > 
> > While you are here could you substitute _malloc by kzalloc and remove
> > explicit casting and memset?
> > 
> 
> Normally, that's the kind of thing we would do in a separate patch
> because or the "one thing per patch" rule.  Eventually someone will do a
> driver wide replacement of _malloc().  Or if the bug fixer wanted, he
> could do it in this patch because it is on the same line and all so it
> counts as a "minor closely related change."  Either way is fine.
> 
> Another way to say this is that since the _malloc() was there in the
> original code and Christian didn't introduce it, then we shouldn't
> reject his patch because of it.  This is staging code, and there are so
> many problems that if you start trying to fix everything you'll just get
> lost.
> 
> In my experience v2 patches are much harder to write than v1 patches.
> Twice in the past few days I have messed up the subject line in my v2
> patches.

I'm not objecting to let green light for it, indeed maybe someone could
change all _mallocs & memsets in that code.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

