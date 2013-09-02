Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3IBXP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:15:26 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39900 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3IBXPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:15:25 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 16:15:14 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] checkpatch: Report missing spaces around trigraphs with
 --strict
Message-ID: <20130902231514.GA1163@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <20130902195056.GB32628@leaf>
 <5224EF32.5060104@roeck-us.net>
 <1378160086.1953.129.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378160086.1953.129.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 03:14:46PM -0700, Joe Perches wrote:
> Spaces around trigraphs are specified by CodingStyle
> but checkpatch is currently silent about them because
> there are many current instances without them.
> 
> Make missing spaces around trigraphs a --strict message.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2817,7 +2817,7 @@ sub process {
>  				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
>  				=>|->|<<|>>|<|>|=|!|~|
>  				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%|
> -				\?|:
> +				\?:|\?|:
>  			}x;

While you're poking at this bit of code, would you mind looking at why
it gives a false positive for spaces around '*' on my recent patch at
http://mid.gmane.org/20130901234251.GB25057@leaf ?  It appears to
mistake the '*' of a pointer for a multiply.

Thanks,
Josh Triplett
