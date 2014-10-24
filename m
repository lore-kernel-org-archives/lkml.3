Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJXS5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:57:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36365 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaJXS47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:56:59 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.152]
In-Reply-To: <544A9F1A.4050303@suse.com>
References: <544A9F1A.4050303@suse.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Fri, 24 Oct 2014 14:56:37 -0400
Message-ID: <CAOFdcFNV9MQQWazo2difPOwfOEbAj=1_2B5+8vWnMd7n3yqTtA@mail.gmail.com>
Subject: Re: [PATCH] vdso: don't require 64-bit math in standalone test
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 2:48 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> The use of 64-bit math on i386 causes build failures:
> vdso_standalone_test_x86.c:(.text+0x101): undefined reference to `__umoddi3'
> vdso_standalone_test_x86.c:(.text+0x12d): undefined reference to `__udivdi3'
>
> Commit adb19fb66ee (Documentation: add makefiles for more targets) is
> now building this by default, so it's failing the kernel build entirely.
>
> Switching the declaration from uint64_t to time_t does the right thing
> and handles the x32 case automatically.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: Peter Foley <pefoley2@pefoley.com>
