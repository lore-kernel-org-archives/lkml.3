Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab3AOXdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:33:54 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58370 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab3AOXdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:33:51 -0500
Date: Tue, 15 Jan 2013 15:33:47 -0800
From: Kent Overstreet <koverstreet@google.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        snitzer@redhat.com, agk@redhat.com, neilb@suse.de
Subject: Re: Bcache v. whatever
Message-ID: <20130115233347.GD26407@google.com>
References: <20130114223202.GV26407@google.com>
 <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com>
 <20130115205912.GA26407@google.com>
 <1358291738.10591.23.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358291738.10591.23.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:15:38PM +0000, James Bottomley wrote:
> I think md integration would be a bit of a mistake, since md is pretty
> much only a raid engine at this point in time.  There are also a couple
> of other dm cache targets, so it would be nice to have one rather than
> three.  This all, however, seems to be under discussion on the dm list.

The raid vs. caching bit is a bit beside the point IMO; they both
aggregate block devices and expose virtual block devices, and the
mechanism for doing so isn't part of the generic framework.

I'm not morally opposed to dm integration, I'm just more comfortable
with the md code and find it easier to understand and work with.

And the goal I care about is just commonality of userspace interfaces
and tooling, which integration with either would accomplish.

> > So I'm not sure why it'd go in via dm, it seems to me it'd make just as
> > much sense for it to go in via Neil Brown's tree. Unless there's
> > something I'm missing?
> 
> Um, well there's no caching patches in the md tree; it's RAID only.  The
> basic caching stuff is all in the dm tree, which is why it's the natural
> one.
> 
> It seems to me that your stuff is progressing on the dm list, so I don't
> really see a need to circumvent the process in the dm tree ... unless
> there's some problem I'm not seeing?

I haven't been active on dm-devel, besides the occasional cross
posting... not sure what activity you're referring to on the dm list,

But if Alasdair wants to pick it up I'm not complaining, I don't
particularly care who merges it.
