Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbbAGLGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:06:55 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:35692 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbbAGLGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:06:54 -0500
Message-ID: <1420628802.3407.4.camel@sipsolutions.net>
Subject: Re: [PATCH] wireless extensions should default to Y
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 07 Jan 2015 12:06:42 +0100
In-Reply-To: <20150107110323.GB7368@amd>
References: <20150107101903.GA6563@amd>
	 <1420627315.3407.2.camel@sipsolutions.net> <20150107110323.GB7368@amd>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 12:03 +0100, Pavel Machek wrote:
> On Wed 2015-01-07 11:41:55, Johannes Berg wrote:
> > On Wed, 2015-01-07 at 11:19 +0100, Pavel Machek wrote:
> > > Do we need following patch on top of
> > > 24a0aa212ee2dbe44360288684478d76a8e20a0a revert?
> > > 
> > > I updated kernel today, and (probably because extensions were not
> > > selectable before), the default choice was "N", which is wrong:
> > > oldconfig should result in compatible choices being made, for example
> > > to help bisect.
> > 
> > I don't believe we need this. It has been defaulting to N for a long
> > time, it's just that it got thrown out of your config due to building
> > inbetween the patch and its revert. Had you built only before and after
> > that wouldn't be an issue.
> 
> Well, I clearly hit the issue. If someone had _not_ build in between,
> the "default y" does not change anything for him, as he will not be
> asked thequestion. If someone starts config from scratch, Y is the
> safe answer.

We've long stated that if really starting from scratch it's the wrong
thing to do and had a default N, so I don't really know why we'd revert
that only to make a short period of bisect slightly happier?

I really don't want to merge this patch and encourage more people to
build with wext enabled.

johannes

