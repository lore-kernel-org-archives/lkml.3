Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBIQdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:33:50 -0500
Received: from 0.mx.nanl.de ([217.115.11.12]:46083 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaBIQds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:33:48 -0500
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 11:33:48 EST
MIME-Version: 1.0
In-Reply-To: <1391952745.25424.6.camel@x220>
References: <1391952745.25424.6.camel@x220>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 9 Feb 2014 17:26:59 +0100
Message-ID: <CAOiHx=mi3sW7C0ZGwAhobRryikMs=Hj0UL19ENuUMECqk0EW5g@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 2:32 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Commit 597ce1723e0f ("MIPS: Support for 64-bit FP with O32 binaries")
> introduced references to two undefined Kconfig macros. CONFIG_MIPS32_R2
> should clearly be replaced with CONFIG_CPU_MIPS32_R2. And CONFIG_MIPS64
> should apparently be replaced with CONFIG_64BIT.

While I agree about the CONFIG_MIPS64 => CONFIG_64BIT replacement, I
wonder if CONFIG_MIPS32_R2 shouldn't rather be CONFIG_CPU_MIPSR2
(maybe even the existing CONFIG_CPU_MIPS32_R2 are wrong here).
CPU_XLP selects CPU_MIPSR2, and CPU_LONGSOON1 selects CPU_MIPS32 and
CPU_MIPSR2, so they should probably be treated the same way as
CPU_MIPS32_R2 (for e.g. the di/ei availability), but since all three
are choice values, there can't be CPU_MIPS32_R2 selected if
CPU_LONGSOON1 or CPU_XLP is chosen.


Regards
Jonas
