Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3JZUCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:02:42 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:51419 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3JZUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:02:41 -0400
Date: Sat, 26 Oct 2013 22:02:37 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] atmusb: Fix dynamic_debug macros
Message-ID: <20131026200237.GA18740@shrek.podlesie.net>
References: <20131026132955.GA9251@shrek.podlesie.net>
 <20131026173730.GA18320@kroah.com>
 <1382813729.3238.8.camel@joe-AO722>
 <1382815736.3238.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382815736.3238.10.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 12:28:56PM -0700, Joe Perches wrote:
> On Sat, 2013-10-26 at 11:55 -0700, Joe Perches wrote:
> > Fix use of atm_dbg to all normal pr_debug not dynamic_pr_debug
> > because dynamic_pr_debug may not be compiled in at all.
> 
> Greg, please don't apply this one.
> I'll resubmit one that actually works.
> 
> (the arg...) should be ...
> 
> > +#define atm_dbg(instance, format, arg...)				\
>                                      ^ oops.
> 
> > +#define atm_rldbg(instance, format, arg...)				\
> > +	pr_debug_ratelimited("ATM dev %d: " format,			\
> > +			     (instance)->atm_dev->number, ##__VA_ARGS__)
> 
> here too.
> 

Yeah, I initially fixed that with changing "##__VAR_ARGS" to "## arg",
but without with "arg..." -> "..." it also compiles and runs correctly.

I tested that only in my configuration - without DEBUG and DYNAMIC_DEBUG
- and compile tested that it with DYNAMIC_DEBUG. If you like you can add:

Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>

BTW: the driver is named usbatm, not atmusb.

Thanks,
Krzysiek
