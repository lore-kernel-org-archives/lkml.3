Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3JCQ1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:27:48 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:64455 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3JCQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:27:46 -0400
MIME-Version: 1.0
In-Reply-To: <524D5DAC.3000004@gmail.com>
References: <52486938.4090009@gmail.com>
	<20130929180101.GB5490@pd.tnic>
	<5248905E.8000801@gmail.com>
	<20130929205051.GD5426@pd.tnic>
	<52489A59.7040108@gmail.com>
	<20130929213026.GF5426@pd.tnic>
	<524D5DAC.3000004@gmail.com>
Date: Thu, 3 Oct 2013 09:27:45 -0700
X-Google-Sender-Auth: eRDQFnvAj-tFKwjZruw8BpZGh50
Message-ID: <CA+55aFwuV4u3ky-XT_P_sCOYjqUW1EvA3Q2NuZ=+LZ5O06jS3g@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer AMD processors
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 5:06 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> improved.  Building kernel 3.12-rc2 with allmodconfig using 8 jobs on a FX-8320 takes
>
> 22 minutes and 57 seconds on a kernel with CONFIG_MK8,
> 21 minutes and 35 seconds on a kernel with CONFIG_GENERIC, and
> 19 minutes and 11 seconds on a kernel with CONFIG_PILEDRIVER.

That's certainly noticeable. Surprisingly so. What makes MK8 so bad in
particular, I wonder?

Just out of interest, have you done any profiles on the kernel cost
here to see what it is that makes such a big difference. Because
normally on a kernel build, I see most of the overhead in path lookup.
But that's only true for otherwise optimized builds that don't have
system call auditing etc debugging that spreads the costs out over
everything..

             Linus
