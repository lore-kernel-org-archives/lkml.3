Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937606Ab3DIK0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:26:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36306 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702Ab3DIK0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:26:22 -0400
Date: Tue, 9 Apr 2013 12:24:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
Message-ID: <20130409102409.GF10243@pd.tnic>
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
 <20130404190731.GG32271@pd.tnic>
 <5163DE7C.7060700@numascale.com>
 <20130409093854.GC10243@pd.tnic>
 <5163E348.7060206@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5163E348.7060206@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:45:44AM +0200, Steffen Persvold wrote:
> Hmm, yes of course. This of course breaks on our slave servers when
> the shared mechanism doesn't work properly (i.e NB not visible). Then
> all cores gets individual kobjects and there can be discrepancies
> between what the hardware is programmed to and what is reflected in
> /sys on some cores..

Hold on, are you saying you have cores with an invisible NB? How does
that even work? Or is it only invisible to sw?

Which would explain why you want the bank4 thing to be per-core.
However, the ugliness with this approach is that you need to note which
cores share the bank and do the proper updates on all sharing cores upon
modifications from sysfs.

Oh well, if you can come up with a clean patchset doing that and without
introducing too much bloat, we can talk about it... :-)

> Ok, we go with our first approach to not create MC4 at all if NB isn't
> visible.

... but this would be the simpler fix. Unless it is still not fixing
everything for you guys.

> We'll redo the patch against the tip:x86/ras branch.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
-- 
