Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab3DZGzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:55:15 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:38541 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab3DZGzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:55:13 -0400
Date: Fri, 26 Apr 2013 08:55:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Basic perf PMU support for Haswell v11
Message-ID: <20130426065503.GA31197@gmail.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> This is based on v7 of the full Haswell PMU support,
> rebased, and stripped down to the bare bones

Ok, I found some time to still squeeze this into the v3.10 x86 PMU bits 
merge window but ran into problems.

You say it's barebones, yet it does not work :-( How well was this 
patch-set tested on non-Haswell hardware, which makes up 99.99% of our 
installed base?

In particular, after applying your patches, 'perf top' stopped working on 
an Intel testbox of mine:

  processor       : 15
  vendor_id       : GenuineIntel
  cpu family      : 6
  model           : 26
  model name      : Intel(R) Xeon(R) CPU           X55600 @ 2.80GHz
  stepping        : 5

'perf top' just does not produce any profiling output - it says 0 events.

> Most interesting new features are not in this patchkit

Sigh, we don't want esoteric Haswell-only features that only a very small 
subset of people will use.

As I mentioned before, we want _EXISTING_ tools to work and we want the 
patchset to be well-tested. Your Haswell-only extensions might be 
'interesting' to you but are completely uninteresting to most users who 
just want bog standard profiling to work!

Until you don't understand that you will run into problems like this, 
putting priorities not into making existing stuff work, but working on 
esoteric extensions and featurities, missing the forest from all the 
trees...

Your stubborn incompetence is the reason why we are at version 11 of the 
patch-set (!) which is _still_ trivially unacceptable and there's _still_ 
no Haswell support in the upstream kernel...

Thanks,

	Ingo
