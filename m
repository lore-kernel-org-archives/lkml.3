Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab3FDUwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:52:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3FDUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:52:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 21/21] clk: ux500: Supply provider look-up functionality to support Device Tree
Date: Tue, 4 Jun 2013 22:52:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org> <1370266965-7901-22-git-send-email-lee.jones@linaro.org> <CACRpkdaNMR=6JT+pi+9aqOJXW3gK9Yb4hztx3rOiY3c+f3UTRA@mail.gmail.com>
In-Reply-To: <CACRpkdaNMR=6JT+pi+9aqOJXW3gK9Yb4hztx3rOiY3c+f3UTRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306042252.03340.arnd@arndb.de>
X-Provags-ID: V02:K0:8/SUhxtDMqsuX9seDVT8+ANMBDKlwvZRjqcL+k3rdTG
 mYIEmqdO8iwi+U0p3ZgCDnt5Liep20XbBIEDDbSPV3uRom4OW8
 puXr6Bldc4xkV1pMYBqpWlltN/nJlxKx+IMLGHJxGRgIwVNEzT
 eRE2MtDa+q6TlNwEYZEQnR1QGrzHf5IQqlweFH0C1ExSkMMQce
 VJsUBlt8ymV1OyU72vwtpk/EiGWgcmXEa3t0J0Y3FfciZwU4Os
 UFeG5UdCK6y7l9ui5BRV/Wa/KfUGgeFjsvCZWpCR+dZ4xfXoWZ
 p8bz6YZ7vtNzy/UihwEc4QjILpeP3ne1Fmre0EPu9gPBp7xzHB
 lWPhd7HTVojK0GhRZvRY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013, Linus Walleij wrote:
> The whole thing is very different from other DT clock things
> I've seen, usually you add a compatible node for each
> clock type, and a node for each physical gate. But there
> may be several ways to skin this cat...
> 

Based on the IRC discussion we had, I would think that the "prcc" clocks
would best be represented using multiple clock-cells since you can describe
them easily a tuple of register index, bit number some way to distinguish
the two types.

The "prcmu" clocks are harder, and we probably need either a more verbose
representation using one node per clock there, or have a single node
for the entire prcmu and not bother to describe them in DT but hardcode
everything in the source. The current patch does the latter, which is
easier now but means we cannot simplify the code much in the future
when we remove ATAGS boot support.

I hope Mike can give some better insight to what his preferences are.

	Arnd
