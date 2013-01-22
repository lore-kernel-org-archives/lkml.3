Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3AVHwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:52:32 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39855 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754307Ab3AVHw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:52:27 -0500
Message-ID: <1358841145.23968.28.camel@joe-AO722>
Subject: Re: [PATCH] lib: vsprintf: Add %pa format specifier for phys_addr_t
 types
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 21 Jan 2013 23:52:25 -0800
In-Reply-To: <1358839767.12502.44.camel@smile>
References: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>
	 <1358839767.12502.44.camel@smile>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 09:29 +0200, Andy Shevchenko wrote:
> On Mon, 2013-01-21 at 21:47 -0800, Stepan Moskovchenko wrote: 
> > Add the %pa format specifier for printing a phys_addr_t
> > type, since the physical address size on some platforms
> > can vary based on build options, regardless of the native
> > integer type.
[]
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
>  @@ -1112,6 +1113,12 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> >  			return netdev_feature_string(buf, end, ptr, spec);
> >  		}
> >  		break;
> > +	case 'a':
> > +		spec.flags |= SPECIAL | SMALL | ZEROPAD;
> > +		spec.field_width = sizeof(phys_addr_t) * 2;

I believe this should be:

	spec.field_width = sizeof(phys_addr_t) * 2 + 2;

