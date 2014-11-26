Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaKZP2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:28:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbaKZP2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:28:48 -0500
Date: Wed, 26 Nov 2014 10:28:43 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com, gregkh@linuxfoundation.org,
        masami.hiramatsu@gmail.com, linux-kernel@vger.kernel.org,
        corbet@lwn.net
Subject: Re: dm-writeboost: About inclusion into mainline
Message-ID: <20141126152843.GC30136@redhat.com>
References: <5475EB77.3050004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5475EB77.3050004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26 2014 at 10:02am -0500,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Hi,
> 
> I am wondering what's the next step of dm-writeboost, my log-structured SSD-caching driver.
> I want to discuss this.
> 
> I will start from introducing my activity on dm-writeboost.
> It was more than a year ago that I proposed my dm-writeboost for staging.
> Mike Snitzer, a maintainer of device-mapper, rejected it because dm-writeboost at that moment wasn't even suitable for staging.
> (http://www.redhat.com/archives/dm-devel/2013-September/msg00075.html)
> It is clear that the comment was really right. The code was actually terrible.
> Since then, with helps of DM guys, dm-writeboost's design and implementation has been polished.
> And it was included into Joe's linux-2.6 where he develops his drivers.
> (https://github.com/jthornber/linux-2.6/tree/thin-dev/drivers/md)
> I found some bugs and fixed them after this inclusion. I am confident the quality is good enough for staging.
> 
> Now, I can't find the way how I go over the wall.
> It seems that third party drivers are rarely merged into the md.
> The fact is, no third party driver (meaning proposed by other than RH) was included since I am involved with device-mapper, for 2 years.
> I am really afraid dm-writeboost will never be into the md ever after.
> 
> In one sense, this sounds too conservative. New features are always rejected. As a result, third party developers, including me, are losing their willingness.

You're painting with a really wide-brush here.  Both dm-verity and
dm-switch started out as targets from 3rd party developers (Google and
Dell/Equallogic respectively).  But while their feature was needed their
implementation was lacking, so Mikulas rewrote them before they were
included.

But yes, in general, I need to do better about getting to
review/inclusion of 3rd party DM targets.  I have my hands full
maintaining what DM targets we already have (not to mention DM core
itself).

It isn't just full targets (like DM dedup or DM lightnvm) that need
proper review.  It is also DM core changes like adding blk-mq support to
request-based DM.  Those changes are very much on my TODO.  DM dedup and
the blk-mq changes near the top!

But as you can see from what I've staged for 3.19 inclusion I haven't
been sitting around idle:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19

Though you'll note that the focus of development has been on improving
both DM thinp and DM cache (and DM core as needed).  Those targets are
the bread winners from my perspective (lots of consumers and need for
enterprise stability).

All said, I _should_ be able to dedicate time to my backlog of DM review
tasks the first few weeks of Decemeber.  But sadly that doesn't include
time for dm-writeboost yet.

> As you know, developing driver is a hard work and spend lot of
> time. Actually, I spent hundreds or thousands of my private hours on
> my driver (hoping that my driver will be included and become famous)
> but I am almost giving up dm-writeboost if it has no hope. I know,
> storage softwares should become safe-side but I also know that
> willingness is the only key for non-paid development.

If you're looking for fame you're developing the wrong software.  You're
working on a well-worn software layer.

Upstream has both dm-cache and bcache.  Please demonstrate that
dm-writeboost offers an advantage over either of these already upstream
caching solutions with at least _some_ convincing benchmark data.

Mike
