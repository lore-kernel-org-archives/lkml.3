Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbaGAWGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:06:45 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53317 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbaGAWGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:06:44 -0400
Date: Wed, 2 Jul 2014 01:06:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers: remove fs.h from poll.h
Message-ID: <20140701220642.GA3150@p183.telecom.by>
References: <20140701200150.GA31103@p183.telecom.by>
 <20140701134338.1d221dd127ffef4c25e86800@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701134338.1d221dd127ffef4c25e86800@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 01:43:38PM -0700, Andrew Morton wrote:
> On Tue, 1 Jul 2014 23:01:50 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > fs.h is new sched.h!
> > 
> > Start removing unnecessary fs.h inclusions.
> > 
> > In the end of the whole series ~2000 useless fs.h inclusions are gone
> > (just need more comple testing).
> > 
> 
> This changelog is rather confusing.
> 
> The patch adds lots *more* fs.h inclusions.  I *think* the intent is to
> remove one nested inclusion in poll.h.  But that contradicts your third
> paragraph.
> 
> Help us out here, OK?

fs.h inclusion is unnecessary because it is only needed
for "struct file" forward declaration.

Those fs.h inclusions are fixing inevitable compilation failures.
There maybe more compilation failures.

What I did to get 2000 number is:
* make allmodconfig
* make
* touch include/linux/fs.h
* make
* [count how many files were rebuilt]

After more header tweaking the number of files that were rebuilt dropped
by ~2000 but code still compiles, which means fs.h inclusions were useless.

This is first patch in series. Same thing we did with sched.h earlier.

	Alexey
