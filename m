Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3JGTen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:34:43 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46125 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3JGTem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:34:42 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 7 Oct 2013 12:34:33 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, gregkh@linux-foundation.org,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict
 check only
Message-ID: <20131007193433.GF13643@jtriplet-mobl1>
References: <20131007191835.GA28737@jtriplet-mobl1>
 <1381174106.2081.207.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381174106.2081.207.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 12:28:26PM -0700, Joe Perches wrote:
> On Mon, 2013-10-07 at 12:18 -0700, Josh Triplett wrote:
> > The 80-character limit is not a hard-and-fast rule, nor should it be
> > applied blindly by people running checkpatch and fixing its warnings.
> > Sometimes it's better to violate the 80-character "limit" in the name of
> > readability, and when it isn't, it's often better to refactor into a
> > function or otherwise restructure the code rather than just finding
> > increasingly awkward places to break lines.
> > 
> > Thus, change checkpatch's LONG_LINE warning to a --strict CHK instead.
> > Anyone wanting to use checkpatch to check for this can easily enough
> > enable --strict or turn on LONG_LINE explicitly, but it shouldn't be
> > part of the default warnings.
> 
> I don't agree with this.
> 
> CodingStyle says:
> ----------------------
> The limit on the length of lines is 80 columns and this is a strongly
> preferred limit.
> ----------------------

Which is the subject of much controversy and extensive discussion, and
the consensus on the list (including by many maintainers) frequently
differs from that.

> People should be encouraged to use 80 column lines and as well
> should learn to ignore messages they don't agree with.

I've seen far more examples of the 80-column limit making code less
readable rather than more.  It's only really helpful when it forces code
restructuring, *not* when it just forces an arbitrary line break.

> If people are using checkpatch prior to any scripted git am,
> then just as easily they could add --ignore=LONG_LINE.

Which random folks running checkpatch on staging drivers and trying to
help don't necessarily know to do.  The defaults should cater to the
primary use case, and the 80-column limit is not something to apply
blindly.  It falls in the same category as some of the warnings the
kernel emits with W=2 or so: sometimes helpful, often noise.

- Josh Triplett
