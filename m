Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaFZT7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:59:24 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39823 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaFZT7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140626195629.GC5714@two.firstfloor.org>
References: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
 <20140626195629.GC5714@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 26 Jun 2014 12:59:01 -0700
Message-ID: <CALCETrVBKno2skh3zR=1GYuojwPhYPLD=1HFcLMXjStS+0SPJQ@mail.gmail.com>
Subject: Re: [PATCH] x86_64,entry: Fix RCX for traced syscalls
To: Andi Kleen <andi@firstfloor.org>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:56 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> show RCX == RIP even under strace.
>
> If you think it's really worth the extra instruction?

Hard to say.  That extra instruction only happens on slow paths, so I
suspect the slowdown is negligible.  On the other hand, having syscall
show a blatant difference in behavior between traced and untraced
processes seems unfortunate.

>
> It's not wrong, but it's not clear if it's useful.

--Andy
