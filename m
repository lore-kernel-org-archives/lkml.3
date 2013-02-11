Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3BKRPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:15:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57872 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740Ab3BKRPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:15:46 -0500
Date: Mon, 11 Feb 2013 18:15:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, head_32: Remove second CPUID detection from
 default_entry
Message-ID: <20130211171541.GD2683@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <1360592538-10643-1-git-send-email-bp@alien8.de>
 <1360592538-10643-4-git-send-email-bp@alien8.de>
 <18557aed-383a-4454-8222-3d2c0f0a78be@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18557aed-383a-4454-8222-3d2c0f0a78be@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 07:49:14AM -0800, H. Peter Anvin wrote:
> What about CPUs with inconsistent cpuid levels? Yes, they can and do
> happen, as we discussed on IRC.

Yes, this should still work. We're doing the EFLAGS.ID dance right at
the beginning of default_entry on each cpu and cache cpuld level in
new_cpu_data for the time we're in this code.

What this particular patch removes is the yet-another EFLAGS.ID dance
which we IMHO unnecessarily did after enabling paging.

So basically nothing changes wrt handling inconsistent cpuid levels and
MSR mis-programming - we still should be taking care of those cases.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
