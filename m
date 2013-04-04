Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764383Ab3DDTHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:07:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45642 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764311Ab3DDTHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:07:36 -0400
Date: Thu, 4 Apr 2013 21:07:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
Message-ID: <20130404190731.GG32271@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steffen Persvold <sp@numascale.com>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com>
 <20130404161340.GF32271@pd.tnic>
 <515DC0FA.1040408@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515DC0FA.1040408@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 08:05:46PM +0200, Steffen Persvold wrote:
> It made more sense (to me) to skip the creation of MC4 all together
> if you can't find the matching northbridge since you can't reliably
> do the dec_and_test() reference counting on the shared bank when you
> don't have the common NB struct for all the shared cores.
>
> Or am I just smoking the wrong stuff ?

No, actually *this* explanation should've been in the commit message.
You numascale people do crazy things with the hardware :) so explaining
yourself more verbosely is an absolute must if anyone is to understand
why you're changing the code.

So please write a detailed commit message why you need this change,
don't be afraid to talk about the big picture.

Also, I'm guessing this is urgent stuff and it needs to go into 3.9?
Yes, no? If yes, this patch should probably be tagged for stable.

Also, please redo this patch against tip:x86/ras which already has
patches touching mce_amd.c.

Oh, and lastly, needless to say, it needs to be tested on a "normal",
i.e. !numascale AMD multinode box, in case you haven't done so yet. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
-- 
