Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3IXJaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:30:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab3IXJaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:30:01 -0400
Date: Tue, 24 Sep 2013 11:29:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, thomas@m3y3r.de, list@osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to
 memdup
In-Reply-To: <5237A5D5.8010006@canonical.com>
Message-ID: <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz>
References: <5237430B.5040009@canonical.com> <20130916203824.GP25896@mwanda> <52376ED9.5080208@canonical.com> <20130916210503.GQ25896@mwanda> <5237A5D5.8010006@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Joseph Salisbury wrote:

> >> Can you explain a little further?  Mark commit a4a23f6 as bad?  An
> >> initial bisect already reported that was the first bad commit, so it
> >> can't be marked bad.  The oops on memcpy() happens after commit a4a23f6
> >> is reverted.  The oops on memcpy() did not happen before a4a23f6 was
> >> committed, so I assume this new oops was introduced by a change later.
> >>
> >> Right now I'm bisecting down the oops on memcpy() by updating the bisect
> >> with good or bad, depending if the test kernel hit the oops.  I then
> >> revert a4a23f6, so that revert is the HEAD of the tree each time before
> >> building the kernel again(As long as the commit spit out by bisect is
> >> after when a4a23f6 was introduced).
> > Yep.  Please continue bisecting the memcpy() oops.
> >
> > kmemdup() is just a kzalloc() followed by a memcpy().  When we split it
> > apart by reverting the patch then we would expect the oops to move to
> > the memcpy() part.  Somehow "desc" is a bogus pointer, but I don't
> > immediately see how that is possible.
> >
> > regards,
> > dan carpenter
> 
> Thanks for the details.  We'll continue the bisect and let you know how
> it goes.

Did this please yield any useful result?

Thanks,

-- 
Jiri Kosina
SUSE Labs
