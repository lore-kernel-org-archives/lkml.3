Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab3GLMfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:35:21 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53422 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3GLMfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:35:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130712121354.GG24008@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com> <20130712075602.GA4002@gmail.com>
 <20130712080145.GC24008@pd.tnic> <20130712101319.GA13421@gmail.com>
 <20130712102326.GE24008@pd.tnic> <20130712041810.53c86e5f.akpm@linux-foundation.org>
 <20130712121354.GG24008@pd.tnic>
From: Florian Fainelli <florian@openwrt.org>
Date: Fri, 12 Jul 2013 13:34:38 +0100
X-Google-Sender-Auth: Q8nHTX6ZMdSJditYiupGTY-abJY
Message-ID: <CAGVrzcZq-NQU=1UY7FpXPXZPFjJV7CQMsNQJbdY=bLTFVqGQHA@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
To: Borislav Petkov <bp@alien8.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2013/7/12 Borislav Petkov <bp@alien8.de>:
> On Fri, Jul 12, 2013 at 04:18:10AM -0700, Andrew Morton wrote:
>> Well y'know, if whining fixed bugs then there would be no problem here
>> at all.
>
> I know. I decided to whine this time and not try to fix it because
> attempting to fix every fallout I'm seeing in the tree with randconfigs
> is a full-time job and the *actual* job doesn't see any progress.
>
> And in all fairness, if someone were reporting an issue against my code,
> I'll try to do my very best to fix it as quickly aas possible, instead
> of ignoring it.
>
> So actually, the right thing to do in such cases is back out half-cooked
> stuff from the tree until it gets fixed. That'll give the authors the
> right incentive. But this is just me.
>
>> This problem came up briefly and I thought it had been adequately
>> addressed. Now a month or two later we find out who are the people who
>> can't be bothered testing -next, but think it terribly important that
>> others do so.
>
> Yeah, if everyone would put their money where their mouth is...

Shall we provide a shell script wrapper for all of these compressor
commands which would test for the utility presence and issue a BIG FAT
WARNING if not, but still create the file not to make the kernel build
fail? I guess we could probably do this in the Makefile directly as
well.
--
Florian
