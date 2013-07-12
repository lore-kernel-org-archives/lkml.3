Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab3GLMrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:47:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51720 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964794Ab3GLMrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:47:17 -0400
Date: Fri, 12 Jul 2013 14:46:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-ID: <20130712124657.GH24008@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
 <20130712075602.GA4002@gmail.com>
 <20130712080145.GC24008@pd.tnic>
 <20130712101319.GA13421@gmail.com>
 <20130712102326.GE24008@pd.tnic>
 <20130712041810.53c86e5f.akpm@linux-foundation.org>
 <20130712121354.GG24008@pd.tnic>
 <CAGVrzcZq-NQU=1UY7FpXPXZPFjJV7CQMsNQJbdY=bLTFVqGQHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGVrzcZq-NQU=1UY7FpXPXZPFjJV7CQMsNQJbdY=bLTFVqGQHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 01:34:38PM +0100, Florian Fainelli wrote:
> Shall we provide a shell script wrapper for all of these compressor
> commands which would test for the utility presence and issue a BIG FAT
> WARNING if not, but still create the file not to make the kernel build
> fail? I guess we could probably do this in the Makefile directly as
> well.

I don't know how that would work with the main kernel Makefile
but we do those kinds of tests in perf before we build it so
that we can save ourselves the time spent on a failed build:
2209001fd895e8932ae2c85bfca233758234499a.

This should probably work if you add a prerequisite target which runs
early in the build process and checks for all the userspace tools
required for the build.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
