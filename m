Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3HEJM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:12:26 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44699 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3HEJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:12:25 -0400
Date: Mon, 5 Aug 2013 11:12:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130805091221.GB26940@gmail.com>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <87fvuozerv.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvuozerv.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi,
> 
> On Mon, 5 Aug 2013 01:23:20 -0700, Christoph Hellwig wrote:
> > On Mon, Aug 05, 2013 at 10:16:41AM +0200, Ingo Molnar wrote:
> >> If you want fewer dependencies then build with 'make NO_GTK=1'.
> >
> > Doesn't help the distros.  Installing perf and pulling all the 
> > graphics libraries in is highly annoying, especially in size 
> > constrained VM or Cloud images.  Having a separate binary or at least 
> > an ldopen()able plugin that can go into a separate package is highly 
> > desirable.
> 
> I wrote a patch series [1] separating gtk code to a dso and use it with 
> libdl last year.  But I didn't get much feedback probably due to the 
> mistake of not installing the dso to a proper place.  It'd be great if 
> you guys take a look at it and give some comments.
> 
> Thanks,
> Namhyung
> 
> 
> [1] https://lkml.org/lkml/2012/11/14/510

Assuming that in the normal case it can be made to work like a full build 
of perf today (i.e. without forcing LD_PRELOAD) then splitting the 
libraries away looks like a much better solution than splitting the 
binary.

Thanks,

	Ingo
