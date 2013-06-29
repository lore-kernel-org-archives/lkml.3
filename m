Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3F2X4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:56:32 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45632 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3F2X4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130628140938.GA24819@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
	<20130628111948.GA31065@gmail.com>
	<20130628140938.GA24819@pd.tnic>
Date: Sat, 29 Jun 2013 16:56:30 -0700
Message-ID: <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 7:09 AM, Borislav Petkov <bp@alien8.de> wrote:

> Btw, do we have any perf data showing any improvements from this patch?

I wrote a simple test the measures the time it takes to acquire and
release  an uncontended mutex (i.e., we always take the fast path)
100k times. I ran it a few times, the original code averages
2.743436ms, and the new code averages 2.101098ms, so it's about 23% improvement.

I also think the code looks cleaner this way.
