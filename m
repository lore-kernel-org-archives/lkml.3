Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937163Ab3DIJjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:39:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44262 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937148Ab3DIJi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:38:57 -0400
Date: Tue, 9 Apr 2013 11:38:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
Message-ID: <20130409093854.GC10243@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5163DE7C.7060700@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:25:16AM +0200, Steffen Persvold wrote:
> Why not let all cores just create their individual kobject and skip
> this "shared" nb->bank4 concept ? Any disadvantage to that (apart from
> the obvious storage bloat?).

Well, bank4 is shared across cores on the northbridge in *hardware*.
So it is only logical to represent the hardware layout correctly in
software.

Also, if you want to configure any settings over one core's sysfs nodes,
you want those to be visible across all cores automagically:

# echo 12 > machinecheck2/northbridge/dram/threshold_limit
# grep . -Er /sys/devices/system/machinecheck | grep -E "dram.*threshold_limit"
/sys/devices/system/machinecheck/machinecheck0/northbridge/dram/threshold_limit:12
/sys/devices/system/machinecheck/machinecheck1/northbridge/dram/threshold_limit:12
/sys/devices/system/machinecheck/machinecheck2/northbridge/dram/threshold_limit:12
/sys/devices/system/machinecheck/machinecheck3/northbridge/dram/threshold_limit:12
/sys/devices/system/machinecheck/machinecheck4/northbridge/dram/threshold_limit:12
/sys/devices/system/machinecheck/machinecheck5/northbridge/dram/threshold_limit:12
/sys/devices/system/machinecheck/machinecheck6/northbridge/dram/threshold_limit:12
/sys/devices/system/machinecheck/machinecheck7/northbridge/dram/threshold_limit:12

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
