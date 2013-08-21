Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3HUVKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:10:30 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59251 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3HUVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:10:27 -0400
Date: Wed, 21 Aug 2013 14:10:35 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
Message-ID: <20130821211035.GB4657@kmo-pixel>
References: <20130814225904.GA6427@kmo-pixel>
 <520C788A.1060208@profihost.ag>
 <520DFAB4.1050402@profihost.ag>
 <52114614.4070509@profihost.ag>
 <20130819222718.GA32104@kmo-pixel>
 <52132243.8050803@profihost.ag>
 <521323D1.1070503@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521323D1.1070503@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:07:45AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 20.08.2013 10:01, schrieb Stefan Priebe - Profihost AG:
> > Am 20.08.2013 00:27, schrieb Kent Overstreet:
> >> On Mon, Aug 19, 2013 at 12:09:24AM +0200, Stefan Priebe wrote:
> >>>
> >>> Vanilla 3.10.7 + bcache: Fix a writeback performance regression
> >>>
> >>> http://pastebin.com/raw.php?i=LXZk4cMH
> >>
> >> Whoops, at first I thought this was the same bug as one I'd already been
> >> chasing down that had been a harmless bug - turns out I didn't look
> >> closely enough at the backtrace.
> >>
> >> What happened is background writeback is deadlocking, because for some
> >> reason the workqueue it's running out of is a singlethreaded workqueue,
> >> so as soon as it decides to queue enough writeback bios that it has to
> >> sleep on that semaphore (which often won't happen due to the PD
> >> controller based ratelimiting) - boom, deadlock.
> >>
> >> Here's the fixup patch I just tested and am applying:
> 
> Oh i'm now seeing very high CPU spikes of kworker... i don't see if i
> remove bcache: Fix a writeback performance regression.

*swears*

I just saw that this morning, but I assumed it was a bug in my stripe
aware scan code that isn't in this branch yet - thanks for letting me
know that's not the case.

I shall work on a fix for the fix...
