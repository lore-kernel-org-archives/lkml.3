Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaHRK74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:59:56 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:34800 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHRK7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:59:54 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21489.56485.380163.904338@gargle.gargle.HOWL>
Date: Mon, 18 Aug 2014 12:59:49 +0200
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rt_sigreturn rejects a substitute stack frame as invalid.
In-Reply-To: <fadbcf1c3708.53f150fb@langara.bc.ca>
References: <fadbcf1c3708.53f150fb@langara.bc.ca>
X-Mailer: VM 8.1.2 under 24.3.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Stewart-Gallus writes:
 > Hello,
 > 
 > I'm not totally sure that GLibc's setcontext is safe to use in a
 > signal handler. So, I decided I was going to play things safe and let
 > rt_sigreturn switch stacks for me instead. However, rt_sigreturn seems
 > to reject my substitute stack frame as invalid and I'm not sure why.

I did similar things at my previous work (doing dynamic binary
instrumentation and virtualization of user-space binaries; can't
share the code alas, it's proprietary), but my code operated
directly on top of the kernel/user-space API, using the actual
kernel/user-space data structures rather than glibc's fake ones.

If you're sure that it's the kernel's rt_sigreturn and not whatever
glibc runs before it that complains, then a simple way of debugging
this is to modify your kernel to printk some diagnostics whenever
rt_sigreturn decides to error out.

You may also want to check out the 'pth' package.
