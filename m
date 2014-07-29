Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaG2Op2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:45:28 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64546 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaG2OpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:45:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Agner <stefan@agner.ch>, shawn.guo@freescale.com,
        kernel@pengutronix.de, peter.chen@freescale.com,
        linux-kernel@vger.kernel.org, jingchang.lu@freescale.com
Subject: Re: [PATCH] ARM: imx: clk-vf610: introduce clks_init_on
Date: Tue, 29 Jul 2014 16:44:31 +0200
Message-ID: <2815679.ZycfkLhBgI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406643628-4061-1-git-send-email-stefan@agner.ch>
References: <1406643628-4061-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DztwL3Tj4qDOFCpMXbmLPLrndaMDtrvF9LEunnerC4y
 9l6SlUCkFmohlU+DDd2ao6xEm+sBjGjNMARUoKfF0OXXBTuHZG
 6/8TNql1BnMAN9qMuRLQEzJbRlmI7qfzdp2TWv+Hdpzbk+g0pt
 m4s3zkJYXu60TBWaDrFsyN6Rh4srDh8e/A3/H4nVm531YgTOYm
 MAyiG0b7U5PpEO2wAyiGKhxmY8vRwuUfaU2EWQBqJN5yW8OjOD
 neZ1gl3J0C29XVoXE9KXJrbKyLbucVEs+yjyghE996s81xDdnj
 AHBcqllEyss/E9agkXV3PZN7RIq9g7keh38xJfd/WZbqoUjgVO
 2edRtVGJCKrdJOWCizpE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2014 16:20:28 Stefan Agner wrote:
> At the end of the boot process, the clock framework might disable
> required main PLL's. So far, this was no issue since drivers
> requested clocks, which are descended of the main PLL's (e.g.
> pll1_pfd1, which provides the system clock).
> 
> To archive the full 500MHz system clock, DDR clock need to be a
> descendant of PLL2 rather than PLL1 (DDRC_CLK_SEL set to 0). The
> bootloader sets up the clocks accordingly before making use of
> DDR at all. However, in Linux, there is no driver using PLL2,
> which lead to PLL2 being disabled by the clock framework.
> 
> With this patch, we make sure that the main system clock and the
> DDR clock are initially enabled and are kept enabled.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> 

Wouldn't it be better to list this in the DT as a default for
the respective clocks?

	Arnd
