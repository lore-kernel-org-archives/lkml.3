Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942Ab3IPVFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:05:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26131 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3IPVFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:05:36 -0400
Date: Tue, 17 Sep 2013 00:05:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: thomas@m3y3r.de, Jiri Kosina <jkosina@suse.cz>, list@osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to memdup
Message-ID: <20130916210503.GQ25896@mwanda>
References: <5237430B.5040009@canonical.com>
 <20130916203824.GP25896@mwanda>
 <52376ED9.5080208@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52376ED9.5080208@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 04:49:29PM -0400, Joseph Salisbury wrote:
> On 09/16/2013 04:38 PM, Dan Carpenter wrote:
> > On Mon, Sep 16, 2013 at 01:42:35PM -0400, Joseph Salisbury wrote:
> >> Reverting the patch changes the driver back to useing kzalloc() and
> >> memcpy() instead of  kmemdup.  Doing so has uncovered another bug, which
> >> causes an oops on memcpy()[1].  We are in the process of bisecting that
> >> one now and will provide the results.
> > The two bugs are the same it's that the code has shifted a little.  Mark
> > the commit as buggy and continue with the git bisect.
> >
> > regards,
> > dan carpenter
> Can you explain a little further?  Mark commit a4a23f6 as bad?  An
> initial bisect already reported that was the first bad commit, so it
> can't be marked bad.  The oops on memcpy() happens after commit a4a23f6
> is reverted.  The oops on memcpy() did not happen before a4a23f6 was
> committed, so I assume this new oops was introduced by a change later.
> 
> Right now I'm bisecting down the oops on memcpy() by updating the bisect
> with good or bad, depending if the test kernel hit the oops.  I then
> revert a4a23f6, so that revert is the HEAD of the tree each time before
> building the kernel again(As long as the commit spit out by bisect is
> after when a4a23f6 was introduced).

Yep.  Please continue bisecting the memcpy() oops.

kmemdup() is just a kzalloc() followed by a memcpy().  When we split it
apart by reverting the patch then we would expect the oops to move to
the memcpy() part.  Somehow "desc" is a bogus pointer, but I don't
immediately see how that is possible.

regards,
dan carpenter
