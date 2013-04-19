Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3DSTLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:11:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51648 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab3DSTLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:11:39 -0400
Date: Fri, 19 Apr 2013 21:11:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        fenghua.yu@intel.com
Subject: Re: [PATCH] x86: Add check for P5 to microcode_intel_early
Message-ID: <20130419191128.GA21991@pd.tnic>
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 06:23:03PM +0100, Bryan O'Donoghue wrote:
> Architectural MSRs associated with microcode are for P6 or higher.
> Add a check to early microcode to detect < P6.
> 
> Without a check for < P6 - we end up reading from unimplemented MSRs
> on Pentium.

Is this something you're actually seeing on some box or just found by
staring at the code?

In any case, the family checks should go into the ucode driver entry
points in arch/x86/kernel/microcode_core_early.c. AFAICT, x86_vendor()
is a good candidate to be taught to read out the family too and return
X86_VENDOR_UNKNOWN if < P6. Or something to that effect.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
