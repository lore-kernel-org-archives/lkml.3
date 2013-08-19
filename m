Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab3HSSPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:15:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab3HSSP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:15:29 -0400
Date: Mon, 19 Aug 2013 14:15:25 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Message-ID: <20130819181524.GA28765@redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
 <20130819140016.GB27167@redhat.com>
 <1376934845.24869.43.camel@bobble.lax.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376934845.24869.43.camel@bobble.lax.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19 2013 at  1:54pm -0400,
Frank Mayhar <fmayhar@google.com> wrote:

> On Mon, 2013-08-19 at 10:00 -0400, Mike Snitzer wrote:
> > Performance isn't the concern.  The concern is: does DM allow for
> > forward progress if the system's memory is completely exhausted?
> > 
> > This is why request-based has such an extensive reserve, because it
> > needs to account for cloning the largest possible request that comes in
> > (with multiple bios).
> 
> Thanks for the response.  In our particular case, I/O will be file
> system based and over a network, which makes it pretty easy for us to be
> sure that large I/Os never happen.  That notwithstanding, however, as
> you said it just seems reasonable to make these values configurable.
> 
> I'm also looking at making some similar constants in dm-verity and
> dm-bufio configurable in the same way and for similar reasons.

OK, would be helpful if you were to split each patch out, e.g. separate
patches for DM core, verity, bufio, etc.  Reserve the background context
to the 0th patch header (or DM core patch).  With more precise patch
headers that document the new tunable that is exposed by each patch.

It would also be nice to see these tunables get documented in the
appropriate Documentation/device-mapper/ file too.

Thanks for working on this.  I'll have time to review/assist these
changes in the near term.
