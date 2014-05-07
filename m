Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaEGWPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:15:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45893 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaEGWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:15:47 -0400
Date: Wed, 7 May 2014 23:15:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Raghavendra Ganiga <ravi23ganiga@gmail.com>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: add support for maxim dallas rtc ds1343 and ds1344
Message-ID: <20140507231529.4a3810e5@www.etchedpixels.co.uk>
In-Reply-To: <20140507144248.cf3d5e7411186e2cd616ded8@linux-foundation.org>
References: <1399403036-11377-1-git-send-email-ravi23ganiga@gmail.com>
	<20140507144248.cf3d5e7411186e2cd616ded8@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 14:42:48 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  7 May 2014 00:33:56 +0530 Raghavendra Ganiga <ravi23ganiga@gmail.com> wrote:
> 
> > This is a patch to add support for
> > maxim dallas rtc ds1343 and ds1344
> > 
> > ...
> >
> > +static int ds1343_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
> > +{
> > +	switch (cmd) {
> > +#ifdef RTC_SET_CHARGE
> > +	case RTC_SET_CHARGE:
> > +	{
> > +		int val;
> > +
> > +		if (copy_from_user(&val, (int __user *)arg, sizeof(int)))
> > +			return -EFAULT;
> > +
> > +		return regmap_write(priv->map, DS1343_TRICKLE_REG, val);
> > +	}
> > +	break;
> > +#endif
> > +	}
> 
> Why is RTC_SET_CHARGE defined only for m32r?  It seems pretty generic?
> 
> > +	return -ENOIOCTLCMD;
> > +}
> 
> It's possible that this should be -ENOTTY.  I always forget the rule,
> but Alan never forgets anything ;)

I forget lots 8)

-ENOTTY if it will be returned to user space, -ENOIOCTLCMD is used by
some core code internally as a way for the sub drivers to tell the core
"I didn't handle this, maybe you have a default method ?"

Alan
