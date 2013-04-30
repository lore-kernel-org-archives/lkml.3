Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3D3Otq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:49:46 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:61639 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab3D3Oto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:49:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130430065808.GA19736@gmail.com>
References: <20130430065808.GA19736@gmail.com>
Date: Tue, 30 Apr 2013 07:49:43 -0700
X-Google-Sender-Auth: dwlarKRRXjnDznygHvcPgk-5ckc
Message-ID: <CA+55aFwcX3oKYCFbq4XcX7Y2Yk6BWWKY4TRNOyfeZ9rYrQMRNQ@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler changes for v3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest sched-core-for-linus git tree from:
>
> The main changes in this development cycle were:
>
>   - full dynticks preparatory work by Frederic Weisbecker

Why does this have the crappy cputime scaling overflow code, when we
had a long thread about how to do it right *without* any 64-bit
divides, including a quality-tested patch?

This still has the garbage "div64_u64_rem()" crap which actually SLOWS
DOWN 32-bit code even when not used (becuse it makes "div64_u64()"
calculate it even when unnecessary.

WTF happened here? I and others spent efforts so that we wouldn't need
this kind of crap.

               Linus
