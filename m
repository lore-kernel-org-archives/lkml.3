Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860Ab3DDQNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:13:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50712 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762770Ab3DDQNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:13:44 -0400
Date: Thu, 4 Apr 2013 18:13:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
Message-ID: <20130404161340.GF32271@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>
References: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:52:00PM +0800, Daniel J Blueman wrote:
> On platforms where all Northbridges may not be visible (due to routing, eg on
> NumaConnect systems), prevent oopsing due to stale pointer access when
> offlining cores.
> 
> Signed-off-by: Steffen Persvold <sp@numascale.com>
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

Huh, what's up?

This one is almost reverting 21c5e50e15b1a which you wrote in the first
place. What's happening? What stale pointer access, where? We have the
if (nb ..) guards there.

This commit message needs a *lot* more explanation about what's going
on and why we're reverting 21c5e50e15b1a. And why the special handling
for shared banks? I presume you offline some of the cores and there's a
dangling pointer but again, there are the nb validity guards...

/me is genuinely confused.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
