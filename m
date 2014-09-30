Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaI3BAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:00:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13383 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaI3BAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:00:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Rti05rWnWSFr2FUssCjPTFmc2WicE1iA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 027FF5F0CCC
Date: Mon, 29 Sep 2014 21:00:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: Fixed Conditional white space problems
Message-ID: <20140930010011.GL23926@titan.lakedaemon.net>
References: <20140928220828.GA12566@localhost>
 <20140928221445.GA25174@kroah.com>
 <20140928230216.GF23926@titan.lakedaemon.net>
 <1412037611.10874.1.camel@debian-compaq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412037611.10874.1.camel@debian-compaq>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Mon, Sep 29, 2014 at 07:40:11PM -0500, Eric Rost wrote:
> > >I'll be looking to see that no object
> > code has changed (./scripts/objdiff) across your patch series.
> 
> Hmm... I'm thinking of digging into it, but I'm not sure the #if's can
> be gotten rid of sans object code changes, since its picking codeblocks
> in the precompiler stage, right?

You just have to remain consistent with what's currently being selected.
But yes, you are correct.

And don't get yourself too tied up in knots wrt objdiff-perfection.  I
would take a look at what Joe Perches posted as a starting point.  I
haven't reviewed it in depth yet as I'm wrapped around the axle with
other commitments.

If you get stuck, just ask.  A *little* beating your head against the
wall is part of the learning process, a lot is just unnecessary
frustration.

wrt to this code, we don't necessarily need to see the macros and such
removed.  First step, get them out of the middle of functions.  Second
step, decide which would be better off as static inline functions.  The
rest may be able to go into a common include.

thx,

Jason.
