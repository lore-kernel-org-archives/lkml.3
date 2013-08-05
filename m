Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3HEKMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:12:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53759 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab3HEKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:12:51 -0400
Date: Mon, 5 Aug 2013 11:12:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7] watchdog: Add MOXA ART watchdog driver
Message-ID: <20130805101214.GB7594@e106331-lin.cambridge.arm.com>
References: <1375098093-8975-1-git-send-email-jonas.jensen@gmail.com>
 <1375101228-10930-1-git-send-email-jonas.jensen@gmail.com>
 <20130802114159.GK2884@e106331-lin.cambridge.arm.com>
 <51FBE0D5.3070007@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FBE0D5.3070007@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 05:39:49PM +0100, Guenter Roeck wrote:
> On 08/02/2013 04:41 AM, Mark Rutland wrote:
> > On Mon, Jul 29, 2013 at 01:33:48PM +0100, Jonas Jensen wrote:
> >> Add watchdog driver for MOXA ART SoCs.
> >>
> [ ... ]
> >> +
> >> +	err = watchdog_register_device(&moxart_wdt->dev);
> >> +	if (unlikely(err))
> >> +		return err;
> >
> > This is a probe path. Is the use of unlikely() really appropriate here?
> > I suspect it doesn't make any appreciable difference, and should go.
> >
> Just wondering, for my education - why ? Is there s rule that unlikely()
> shall not be used in the probe path ? If so, I would like to know it and
> its reasoning to be able to apply it to my own reviews.

I thought there had been some discussion on LKML about likely and
unlikely being abused, but in some quick searching I couldn't find the
thread I remembered. I found a comment from Steve Rostedt [1], but
that's not necessarily canonical.

As I understand it, likely() and unlikely() should be used to tell the
compiler to optimise for very specific cases where we know the branch
likelihood far better than the compiler, and the performance gain is
significant (i.e. hot paths). Using them elsewhere may lead to
performance and/or size degradation, as we're asking the compiler to do
something other than what it believes is optimal.

Probing is far from a hot path, and it seems in this case at least that
unlikely() is only present as part of some duplicated black magic.

Thanks,
Mark.

[1] https://lkml.org/lkml/2011/1/3/135
