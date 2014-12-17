Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaLQIJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:09:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45690 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaLQIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:09:50 -0500
Date: Wed, 17 Dec 2014 09:09:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: Re: [PATCH] PM / sleep: add configurable delay for pm_test
Message-ID: <20141217080947.GB2027@amd>
References: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
 <20141213025530.GO21347@ld-irv-0074>
 <20141213083123.GA26129@amd>
 <20141216235813.GI9759@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216235813.GI9759@ld-irv-0074>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 40 lines of code, and new sysfs interface for use by someone who puts
> > the probes on board, anyway... (so should be able to add the single
> > mdelay himself).
> 
> I heard your complaint the first time:
> 
>   https://lkml.org/lkml/2014/9/4/63
> 
> And I responded to it already:
> 
>   https://lkml.org/lkml/2014/9/4/494
> 
> You did not respond, but Chirantan spoke up saying he wanted such a
> patch too. He came up with a very similar solution independently:

I know. I believe your patch is so crazy that no more discussion was neccessary.

>   https://chromium.googlesource.com/chromiumos/third_party/kernel/+/15bccc2c63c3475ef61d3187c73ccf1d80b18c7e
> 
> But since you've decided to make the same comment again, I will detail
> more of the reasons why I think your suggestion ("go add the mdelay
> yourself") is off-base.
> 
>  1. This is behind a debug config option (CONFIG_PM_DEBUG). So what's
>  the problem with improving its usefulness? Non-debug users can easily
>  compile it out if they're worried about 40 lines.

We are talking 40 unneccessary lines of source. Imagine everyone who
needed to change one value added 40 lines of code. Terabyte
kernel. Overengineered. Crazy. Something we'll have to maintain
forever.

Make it module parameter so that the patch is two lines of code. If
that does not work for you, think of something that does.

>  2. The current debug code encodes a particular policy (which kernels
>  generally should not). Is it better if I submit a patch that changes
>  the current magic delay to 60000 milliseconds? What about 1334
>  milliseconds?
> 
>  3. To continue your argument: why would I ever try to patch the
>  upstream kernel, if I'm perfectly capable of doing this myself?

Good questions. Showing that perhaps you should not patch the
upstream.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
