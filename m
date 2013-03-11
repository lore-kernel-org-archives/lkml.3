Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3CKFFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:05:34 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40899 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3CKFFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:05:32 -0400
Date: Sun, 10 Mar 2013 22:05:46 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pavel Machek <pavel@ucw.cz>, grant.likely@secretlab.ca,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux@arm.linux.org.uk,
        arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        rob.herring@calxeda.com, torvalds@linux-foundation.org
Subject: Re: 3.9-rc1 regression in arm dtb build
Message-ID: <20130311050546.GA21863@quad.lixom.net>
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
 <5137C404.9060902@wwwdotorg.org>
 <20130307144506.GB7344@amd.pavel.ucw.cz>
 <5138FDAE.8060202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5138FDAE.8060202@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 01:50:54PM -0700, Stephen Warren wrote:
> On 03/07/2013 07:45 AM, Pavel Machek wrote:
> > Hi!
> >>> commit 499cd8298628eeabf0eb5eb6525d4faa0eec80d8
> >>> Author: Grant Likely <grant.likely@secretlab.ca>
> >>> Date:   Tue Nov 27 16:29:11 2012 -0700
> > ...
> >>> 1) it is inconsistent with 3.8, making switching between 3.9-rc1 and
> >>> 3.8 tricky
> >>
> >> It's pretty easy to locate the DTB by automatically looking in
> >> arch/*/boot/dts first, then if the file doesn't exist there, looking in
> >> arch/*/boot instead as a legacy fallback.
> > 
> > Unfortunately, that does not work. See 2) below. Stale files even
> > survive "make clean".
> 
> Oh right. I guess it works fine when having built 3.7 and then building
> 3.8, since you'd look in the new location first and only fall back to
> the old location if missing. However, if you then switch back to 3.7 to
> test something, I guess that doesn't work so well.
> 
> I tend to always build the dtbs target, so I wasn't affected by this.
> And, often run "git clean -f -d -x" too.
> 
> Grant, what's your call on this issue; should I/you look into ways to
> clean the files better, or do you want to revert this?

I'm not Grant, but I think we're better off cleaning up the current situation
instead of reverting. Otherwise 3.8 will be the oddball weird release; it's
better to get people moved over to the new location.


-Olof
