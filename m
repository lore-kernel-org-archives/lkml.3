Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3EBIcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:32:54 -0400
Received: from mail.nanl.de ([217.115.11.12]:40097 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab3EBIcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <20522420.158691367384219315.JavaMail.weblogic@epml17>
References: <20522420.158691367384219315.JavaMail.weblogic@epml17>
From: Jonas Gorski <jogo@openwrt.org>
Date: Thu, 2 May 2013 10:32:27 +0200
Message-ID: <CAOiHx=mBPHmDse4EwL-+Fgmpz0=XhcgF_0nWdyvErFO4NU7E0Q@mail.gmail.com>
Subject: Re: mips; boot fail after merge 3.9+
To: eunb.song@samsung.com
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>, tglx@linutronix.de,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 6:57 AM, EUNBONG SONG <eunb.song@samsung.com> wrote:
>
> Hello.
> After merge cavium board boots fail, boot log messages are as follows.
> I enabled initcall_debug for debugging.

I can confirm that MIPS does not seem to finish to boot after using
the generic idle loop, I have the same problem on a different platform
(bcm63xx), and bisecting showed the same commit.

(snip)

> I found this issue after cdbedc61c8d0122ad682815936f0d11df1fe5f57.
> And i found something strange. I ran the git show for this commit.
> As below "select GENERIC_IDLE_LOOP" is added for CONFIG_MIPS.
> but the latest arch/mips/Kconfig file has not this one. I have tried to find when this is gone. but i can't find.
> Is there any problem with this?

No, after all architectures were converted to use the generic idle
loop the config symbol was removed, so it's now always on. The problem
is rather that the generic idle loop does not seem to work on MIPS.
Unfortunately due to limited knowledge in this area I can't really
tell which part broke it.


Jonas
