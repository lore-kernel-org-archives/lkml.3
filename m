Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaLAGws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:52:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaLAGwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:52:46 -0500
Date: Mon, 1 Dec 2014 09:52:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2] fs-fat: Less function calls in fat_fill_super() after
 error detection
Message-ID: <20141201065221.GA4994@mwanda>
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5467B12C.4010602@users.sourceforge.net>
 <alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6>
 <54796B5E.5040707@users.sourceforge.net>
 <87sih22sn8.fsf@devron.myhome.or.jp>
 <alpine.DEB.2.10.1411291338530.2378@hadrien>
 <87lhmu2jl8.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhmu2jl8.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 10:59:47PM +0900, OGAWA Hirofumi wrote:
> Julia Lawall <julia.lawall@lip6.fr> writes:
> 
> >> iput() checks NULL of inode. What is wrong just remove NULL check,
> >> instead of adding new jump labels?
> >
> > Personally, I prefer that code that can be statically determined not to
> > need to be executed not to be executed.  It can make the code easier to
> > understand, because each function is only called when doing so is useful,
> > and it can be helpful to static analysis.
> 
> Hm, first of all, we want to prevent the bugs. More labels are more
> chances of bug (and we don't care micro optimize on this error path),
> isn't it?  Increasing the chance of bugs and bothers developers for
> analyzer sounds like strange.

Oh wow!  Absolutely not.  "One Err Bugs" are one of the most common
kinds of bugs we have in the kernel.  This is where you have just one
error label and the bugs look like this:

err:
	kfree(foo->bar);
	kfree(foo);

but foo is NULL.  Mixing the error paths together it always creates
confusion.  I fix so many of these bugs...  We get a few new ones every
week.

Meanwhile Markus's error labels are absolutely useless.  They give no
indication of what going to the label does.

regards,
dan carpenter

