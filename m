Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaIPPUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:20:50 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:58144 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaIPPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:20:48 -0400
Date: Tue, 16 Sep 2014 17:20:46 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916152046.GC32118@x4>
References: <20140914050905.GA296@x4>
 <20140914055450.GB296@x4>
 <CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
 <20140915163740.GA12408@x4>
 <20140916105547.GA1205@quack.suse.cz>
 <20140916144252.GB32118@x4>
 <20140916111331.14303381@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916111331.14303381@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.09.16 at 11:13 -0400, Steven Rostedt wrote:
> On Tue, 16 Sep 2014 16:42:52 +0200
> Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> 
> > commit 458df9fd hardcodes printk_deferred() to KERN_WARNING and inserts
> > the string "[sched_delayed] " before the actual message.
> > However it doesn't take into account the KERN_* prefix of the message,
> > that now ends up in the middle of the output:
> > 
> >  [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
> > 
> > Fix this by just getting rid of the "[sched_delayed] " scnprintf().
> 
> I prefer the "[sched_delayed]" output. It lets us know that the output
> did not come out immediately, which is important sometimes during
> debugging. Otherwise it can confuse people, as printk is suppose to be
> a blocking write.
> 
> Can we instead fix the bug instead of nuking the output? That is, move
> the KERN_* prefix before the "[sched_delayed]" message? I don't think
> it would be that hard. If you want, I'll write that patch (probably
> take me 20 minutes at most), but I'm just coming back from medical
> leave so I prefer not to.

I'll leave it to you. This is just a cosmetic issue, so there's no need
to fix this immediately.

-- 
Markus
