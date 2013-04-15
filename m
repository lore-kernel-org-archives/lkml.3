Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374Ab3DOWEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:04:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60914 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab3DOWEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:04:11 -0400
Date: Tue, 16 Apr 2013 00:04:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130415220406.GD12144@pd.tnic>
References: <51670E51.6020106@zytor.com>
 <20130411202328.GA15955@pd.tnic>
 <20130412053234.GB3887@gmail.com>
 <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
 <20130412094724.GA2368@pd.tnic>
 <20130412112628.GB2368@pd.tnic>
 <20130415100858.GB18024@gmail.com>
 <20130415101734.GB26524@pd.tnic>
 <20130415101825.GD18024@gmail.com>
 <20130415155415.GB12144@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130415155415.GB12144@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 05:54:15PM +0200, Borislav Petkov wrote:
> On Mon, Apr 15, 2013 at 12:18:25PM +0200, Ingo Molnar wrote:
> > It was tip:master with x86/cpu merged in freshly.
> 
> Ok, some more observations. I can trigger some oops similar yours (I
> haven't caught mine yet over serial or such) with latest tip/master +
> tip:x86/cpu.

Ok, here's the deal - it looks like a corruption which causes a couple
of different backtraces with different functions in the call trace. I've
bisected tip:x86/cpu and the evildoers are:

commit 3019653a57585602690fd38679326e9337f7ed7f
Author: Borislav Petkov <bp@suse.de>
Date:   Wed Apr 10 21:37:03 2013 +0200

    x86/fpu: Fix FPU initialization

commit c70293d0e3fef6b989cd8268027d410cf06ce384
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Mon Apr 8 17:57:43 2013 +0200

    x86: Get rid of ->hard_math and all the FPU asm fu


I'll venture a guess and say that if you revert those, your .config
would boot on your K8 too.

So, I'd propose we take those 2 out for more careful inspection and
fixing and the rest of tip:x86/cpu can go upstream in the upcoming merge
window. IMHO of course.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
