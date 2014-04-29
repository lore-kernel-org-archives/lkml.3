Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbaD2USJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:18:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42115 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaD2USH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:18:07 -0400
Date: Tue, 29 Apr 2014 23:17:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Hammond, John" <john.hammond@intel.com>
Cc: Oleg Drokin <green@linuxhacker.ru>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 41/47] staging/lustre/llite: remove dead code
Message-ID: <20140429201753.GF26890@mwanda>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-42-git-send-email-green@linuxhacker.ru>
 <20140429110251.GC26890@mwanda>
 <C6D48C5819337145905EDC9DB164E6971EDC4A18@fmsmsx120.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6D48C5819337145905EDC9DB164E6971EDC4A18@fmsmsx120.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 07:16:54PM +0000, Hammond, John wrote:
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Tuesday, April 29, 2014 6:03 AM
> > To: Oleg Drokin
> > Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org;
> > devel@driverdev.osuosl.org; Drokin, Oleg; Hammond, John
> > Subject: Re: [PATCH 41/47] staging/lustre/llite: remove dead code
> > 
> > On Sun, Apr 27, 2014 at 01:07:05PM -0400, Oleg Drokin wrote:
> > > From: "John L. Hammond" <john.hammond@intel.com>
> > >
> > > In llite remove unused declarations, parameters, types, and unused,
> > > get-only, or set-only structure members. Add static and const
> > > qualifiers to declarations where possible.
> > >
> ...
> > 
> > This is a random grab bag of changes to lots of files.  One thing per
> > patch, etc, next time.
> 
> OK, granted. But some guidance would be welcome here.

No problem.  This is something a lot of people have questions about.

> For
> clean-up work like this, do you want a patch that const-corrects one
> function, a patch that const corrects all functions in a file, or a
> patch that const corrects all functions in a module?

All the functions in the module is fine.

> Is it OK to do const and static correction in the same change?

That's a borderline case.  My first instinct is to say no.

Are we talking about a single variable and making it const in one
patch and then const static in the next?  That's obviously better done
as one change.  But if you're talking about different variables, then
maybe it's better as two changes.  But then maybe some variables should
be made into "static const" and some should be just "static".

These things depend on how you sell it.

[patch] staging: lustre/llite: tighten up static and const declarations

That would be ok probably.

> Is it OK to do const, static, and dead-code in a single file?

No.

Greg compile tests patches but I normally don't.  When I review +static
patches then I pipe it to a command that strips out all the +static
changes and I verify that nothing else changed.  When I review dead code
patches I scan it for places which add code and look at why it does
that.  Then I quickly rescan to verify that the dead code really is
dead.  Normally I can tell just from looking at the patch because there
is an "#if 0" but if it's something more complicated then hopefully it's
explained in the changelog.  If you mix the two kinds of changes then it
messes up my review process.

regards,
dan carpenter

