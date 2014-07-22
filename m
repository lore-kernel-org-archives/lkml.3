Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaGVH5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:57:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:59003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaGVH5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:57:33 -0400
Date: Tue, 22 Jul 2014 09:57:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140722075729.GX3935@laptop>
References: <20140719130602.GA5101@pd.tnic>
 <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic>
 <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic>
 <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 02:56:49PM -0700, Andy Lutomirski wrote:
> > Remember, this is only attempting to be a hardware workaround for a
> > smallish number of systems out there. Most of current machines should
> > have stable and synched TSCs.
> 
> I actually own one of these systems.  It's a Sandy Bridge Core-i7
> Extreme or something like that.

If it is (and it sounds like it is) a single socket, then your unsynced
TSC is likely due to SMM fuckery and the TSCs will drift further and
further apart as (run)time increases due to SMM activity.

The problem Borislav is talking about is multi socket systems, which due
to (failed) board layout get the CPUs powered up 'wrong' and the TSCs
between sockets is offset because of this, its a fixed offset and stable
forever after (until power cycle etc..).

I have one WSM-EP that does this (occasionally).

His initial idea was to re-write the TSC value to match, but since
writing the TSC is expensive (in the 1000s of cycles range) getting an
offset adjustment of 10s of cycles in just right is nigh on impossible.
