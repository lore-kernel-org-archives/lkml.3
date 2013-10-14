Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3JNSAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:00:13 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41277 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3JNSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:00:10 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 14 Oct 2013 11:00:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
        Nandini Hanumanthagowda <nandu.hgowda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Allow spaces before the ':' of a bitfield
Message-ID: <20131014180001.GA20139@jtriplet-mobl1>
References: <20131013121635.GA29395@nandinih-Inspiron-5521>
 <20131013153943.GA27861@kroah.com>
 <687af3bd-edc6-40cf-b994-0d0fdb7cd30d@googlegroups.com>
 <20131014173207.GE16517@jtriplet-mobl1>
 <1381773108.25528.22.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381773108.25528.22.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 10:51:48AM -0700, Joe Perches wrote:
> On Mon, 2013-10-14 at 10:32 -0700, Josh Triplett wrote:
> > checkpatch warns about spaces both before and after the ':' separating a
> > bitfield name from its width.  However, many drivers do put space before
> > the : to line up the widths, which makes the definition significantly
> > more readable; checkpatch should not warn about that.  Remove the
> > warning for space before the ':' of a bitfield.
> 
> There are a _bunch_ of different styles used for
> alignment of bitfields.
> 
> $ grep -rPh --include=*.[ch] \
>   '(?:unsigned\s+|signed\s+|)(char|short|long|long\s+long|\w+_t|(?:__|)(?:u|s)(?:8|16|32|64))\s+\w+\s*:\s*\d+\s*(?:,|;)' *
> 
> spaces before colon
> spaces after colon
> aligned on bitfield size
> 
> I'd just as soon make it a --strict check.

I'd be fine with removing the check entirely, or making it --strict;
however, even for --strict mode I'd suggest applying this patch, as I
don't think checkpatch should ever prohibit spaces before the ':'.

- Josh Triplett
