Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaLET6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:58:08 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57977 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaLET6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:58:06 -0500
MIME-Version: 1.0
In-Reply-To: <1417774227.2232.1.camel@linaro.org>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
 <1417671360-53399-1-git-send-email-wangnan0@huawei.com> <1417710073.2239.10.camel@linaro.org>
 <5481289E.4060504@huawei.com> <1417774227.2232.1.camel@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 5 Dec 2014 19:57:43 +0000
Message-ID: <CAFEAcA8VFzNxWM=7rg0YRo13HLbzitZjW-D0=EoA_diumjv11g@mail.gmail.com>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>, masami.hiramatsu.pt@hitachi.com,
        lizefan@huawei.com, Russell King <linux@arm.linux.org.uk>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2014 at 10:10, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> I don't know much about QEMU and have never used it, but I'm assuming
> QEMU doesn't make any attempt to simulate caches like the data cache,
> instruction cache, TLBs, branch predictor? Does it even emulate multiple
> CPUs with multiple host CPU threads? Basically, I very much doubt QEMU
> is a very good test of kernel code in general, and especially code that
> modifies code and has multiple cpus running in parallel.

You're generally correct here, yes. QEMU doesn't emulate caches
or TLBs or branch predictors, and we currently emulate SMP by
doing round-robin execution on a single host thread (though
we're working on that for performance reasons). There are also
a range of buggy-guest-code conditions (alignment faults, for
instance) which we don't emulate. I tend to think of QEMU's
overall philosophy as "run known-good code quickly" rather
than "diagnose problems in buggy code". So it's definitely wise
to test complicated kernel code like this on real hardware
(though of course QEMU may be very helpful in speeding up the
development cycle compared to h/w).

thanks
-- PMM
