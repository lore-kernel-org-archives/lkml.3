Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaIXJQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:16:38 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64751 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaIXJQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:16:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Behan Webster <behanw@converseincode.com>, linux@arm.linux.org.uk,
        linux@prisktech.co.nz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm, vt8500, LLVMLlinux: Use mcr instead of mcr% for mach-vt8500
Date: Wed, 24 Sep 2014 11:16:24 +0200
Message-ID: <7810937.UX61PvX9nB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411530284-28807-1-git-send-email-behanw@converseincode.com>
References: <1411530284-28807-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CwGZFNebaYnbILZv7TdO+cZIL5kp/55G/f4zxTxfcnF
 TSC4bTz67Pk6x0bgLKVEdw8ksG3UzGK4/fN5tGwdTjAOFxU3Ye
 9ttsIynCb2CbjQFZohEOyeBRtPpBA0x6ISTzy66QIP9gWsuTxP
 QGpLgJjfLIGeYWpthYv97s3XjGLvYdqFp0kLVEP5pwEUFHpQGz
 V/itRvrre1iK2HyMgx9g8KgbYUrP/27/IXuQgk5R2GfjquIuCa
 c8KR1vpkYQEc3PI8E7brcmrDwVx4ANPuhRuWRHSWW3bINvvslW
 vZgKGXvEO3Ukw4cCmw1Oi5Wvk9RX6Jp/16Uc4LPuWpvaxAaMCw
 2VQZWypNez21dc4HWp0M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 20:44:44 Behan Webster wrote:
> The ASM below does not compile with clang and is not the way that the mcr
> command is used in other parts of the kernel.
> 
> arch/arm/mach-vt8500/vt8500.c:72:11: error: invalid % escape in inline assembly string
>         asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
>             ~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
> 1 error generated.
> 
> There are other forms that are supported on different ARM instruction sets but
> generally the kernel just uses mcr as it is supported in all ARM instruction
> sets.

Just for confirm: both forms are actually correct and we don't need this
backported for stable, right?

> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Acked-by: Will Deacon <will.deacon@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Tony, would you like to pick this one up and send it in a pull request
to arm-soc, or should we apply it to fixes-non-critical directly?

	Arnd
