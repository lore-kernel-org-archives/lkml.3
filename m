Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3FRP70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:59:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35751 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab3FRP7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:59:25 -0400
Date: Tue, 18 Jun 2013 17:59:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [x86] only print out DR registers if they are not power-on
 defaults.
Message-ID: <20130618155919.GC13123@pd.tnic>
References: <20130618041132.GA23492@redhat.com>
 <20130618084356.GA13123@pd.tnic>
 <20130618140730.GA1313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130618140730.GA1313@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:07:30AM -0400, Dave Jones wrote:
> My intent here was to ignore cases where the reserved bits haven't
> been set. I occasionally see DR6: 00000000fffe0ff0 for eg.

That's bit 16 which, according to the docs is read-as-1:

"All remaining bits in the DR6 register are reserved. Reserved bits
31:16 and 11:4 must all be set to 1, while reserved bit 12 must be
cleared to 0. In 64-bit mode, the upper 32 bits of DR6 are reserved and
must be written with zeros. Writing a 1 to any of the upper 32 bits
results in a general-protection exception, #GP(0)."

This above if from AMD APM and Intel's SDM has a graphic showing the
exact same thing:

[31:16] = set to 1; [12] = 0b, [11:4] = 1b

So if you see bit 16 cleared, then some BIOS or even hardware is doing
funky things. I wouldn't wonder at all if BIOS dudes used reserved bits
in registers as scratch space.

> But maybe you're right, and that is a clue and is worth printing ? I
> can't personally recall ever diagnosing a bug using those register
> dumps in the last 15 years.

Right, I don't know whether it would always help but if you have an
oops and see, say bit 0 in DR6 set, i.e. a debug exception was caused
by address breakpoint condition in DR0, then that could be useful info,
methinks.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
