Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3DPJZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:25:33 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:59173 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3DPJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:25:32 -0400
Date: Tue, 16 Apr 2013 11:25:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130416092528.GF9569@gmail.com>
References: <20130411202328.GA15955@pd.tnic>
 <20130412053234.GB3887@gmail.com>
 <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
 <20130412094724.GA2368@pd.tnic>
 <20130412112628.GB2368@pd.tnic>
 <20130415100858.GB18024@gmail.com>
 <20130415101734.GB26524@pd.tnic>
 <20130415101825.GD18024@gmail.com>
 <20130415155415.GB12144@pd.tnic>
 <20130415220406.GD12144@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415220406.GD12144@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Apr 15, 2013 at 05:54:15PM +0200, Borislav Petkov wrote:
> > On Mon, Apr 15, 2013 at 12:18:25PM +0200, Ingo Molnar wrote:
> > > It was tip:master with x86/cpu merged in freshly.
> > 
> > Ok, some more observations. I can trigger some oops similar yours (I
> > haven't caught mine yet over serial or such) with latest tip/master +
> > tip:x86/cpu.
> 
> Ok, here's the deal - it looks like a corruption which causes a couple
> of different backtraces with different functions in the call trace. I've
> bisected tip:x86/cpu and the evildoers are:

Correct, 'late effects of memory corruption' was my first impression too, from the 
crash pattern.

> 
> commit 3019653a57585602690fd38679326e9337f7ed7f
> Author: Borislav Petkov <bp@suse.de>
> Date:   Wed Apr 10 21:37:03 2013 +0200
> 
>     x86/fpu: Fix FPU initialization
> 
> commit c70293d0e3fef6b989cd8268027d410cf06ce384
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Mon Apr 8 17:57:43 2013 +0200
> 
>     x86: Get rid of ->hard_math and all the FPU asm fu
> 
> 
> I'll venture a guess and say that if you revert those, your .config
> would boot on your K8 too.
> 
> So, I'd propose we take those 2 out for more careful inspection and
> fixing and the rest of tip:x86/cpu can go upstream in the upcoming merge
> window. IMHO of course.

I've got limited extra capacity right now - but if Peter rebases tip:x86/cpu or 
you send a pullable update of tip:x86/cpu I can stick it into -tip testing and 
yell if it goes wrong.

Thanks,

	Ingo
