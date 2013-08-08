Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966065Ab3HHRtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:49:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49219 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965213Ab3HHRtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:49:08 -0400
Date: Thu, 8 Aug 2013 19:49:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Message-ID: <20130808174906.GC27974@pd.tnic>
References: <20130723230026.394a5ee1@googlemail.com>
 <20130724133254.GE30777@pd.tnic>
 <3E5A0FA7E9CA944F9D5414FEC6C712205A53B73A@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205A53B73A@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 11:34:01PM +0000, Yu, Fenghua wrote:
> > This check won't work when CPU0 is hot added. So we need to find a
> > better way to fix this.
> > 
> 
> Maybe need to change the check as follows to take care of CPU0 hot add case?
> 
> if ((cpu && system_state == SYSTEM_BOOTING) || (system_state == SYSTEM_RUNNING))
> 	load_ucode_ap();

Ok, just for my own understanding - I haven't played with cpu hotadd yet
so when you do this, is the hot-added socket containing the BSP not cpu
0 anymore?

Or when you hot-remove the socket containing the BSP, another AP becomes
the BSP and preserves its old number?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
