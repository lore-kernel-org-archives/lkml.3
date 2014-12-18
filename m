Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaLRVZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:25:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51637 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaLRVZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:25:31 -0500
Date: Fri, 19 Dec 2014 00:25:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: samuel kihahu <skihahu@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        speakup@linux-speakup.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul
Message-ID: <20141218212502.GP4856@mwanda>
References: <1418817362-29088-1-git-send-email-skihahu@gmail.com>
 <20141217121119.GL4856@mwanda>
 <20141217134354.GA585@localhost.localdomain>
 <20141217140322.GM4856@mwanda>
 <20141218144810.GA16115@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218144810.GA16115@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 05:48:10PM +0300, samuel kihahu wrote:
> On Wed, Dec 17, 2014 at 05:03:22PM +0300, Dan Carpenter wrote:
> > On Wed, Dec 17, 2014 at 04:43:54PM +0300, samuel kihahu wrote:
> > > On Wed, Dec 17, 2014 at 03:11:19PM +0300, Dan Carpenter wrote:
> > > > On Wed, Dec 17, 2014 at 02:56:02PM +0300, samuel kihahu wrote:
> > > > > Replacing obsolete simple_strtoul with kstrtoul.
> > > > > 
> > > > 
> > > > Nope.  That's wrong.  Learn how the functions are different beyond just
> > > > the name.
> > > Noted, have made corrections to fit the kstrtoul and handle the return
> > > value.
> > 
> > You have to compile test these things.  Really kernel programming is not
> > a good way to learn how to program.  :(
> > 
> > regards,
> > dan carpenter
> > 
> 
> Appreciate the feedback, have modified the patch, tested and confirmed
> it builds.

No.  It's still really wrong.  One of the key differences between
kstrtoul() and simple_strtoul() is that simple_strtoul() gives you a
pointer to the end of the string.

It's actually best to use simple_strtoul() here.  Checkpatch.pl is
wrong.

As well the new error handling doesn't work at all.

regards,
dan carpenter

