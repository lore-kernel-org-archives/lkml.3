Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3GAWft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:35:49 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46917 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3GAWfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:35:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130701222802.GK23515@pd.tnic>
References: <20130628111948.GA31065@gmail.com>
	<20130628140938.GA24819@pd.tnic>
	<CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
	<20130630220004.GA23124@pd.tnic>
	<20130701075046.GB1681@gmail.com>
	<20130701102306.GC23515@pd.tnic>
	<20130701111122.GA18772@gmail.com>
	<20130701122954.GD23515@pd.tnic>
	<20130701125045.GA24336@gmail.com>
	<20130701144851.GH23515@pd.tnic>
	<20130701222802.GK23515@pd.tnic>
Date: Mon, 1 Jul 2013 15:35:47 -0700
Message-ID: <CANeycqoq8LwLMoXEYdPE6m9eKVB7pRLw1hkSCjJ=jjDj9ej-Cw@mail.gmail.com>
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

On Mon, Jul 1, 2013 at 3:28 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> perf stat --repeat 10 -a --sync --pre 'make -s clean; echo 1 > /proc/sys/vm/drop_caches' make -s -j64 bzImage

How many CPUs do you have in your system? Maybe -j64 vs -jNUM_CPUs
affects your measurements as well.
