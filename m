Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaK1VZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:25:06 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:55081 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaK1VZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:25:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
Date: Fri, 28 Nov 2014 22:24:31 +0100
Message-ID: <2716009.DOfHfaSPkY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7cd7c820d32cb04fa1d59889d16666a9@agner.ch>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch> <34359137.rt8QrS7shW@wuerfel> <7cd7c820d32cb04fa1d59889d16666a9@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:O3KYJ4v49/PTH0PCvNyYjk2dQ6OaMhM4waNbEmnkL3e
 mlfBkHj+ZMdp3kwtI3tity7+nuCj0F6eSH/SI4s1tPNfPj1rl2
 hoeakMo6iUQLO9zL+qLvsv1CsQwaozHUAVYlz0CES7ovDsvPyR
 HFl6S8LfcV1xZK7iBTpMz7C8NtsBIJGobKF4394zd7QgrUiBru
 dUMGXVpxaZEldC46jYdMhxoGjDjAPfsKUHvv9pN/cjEL4UfgTU
 NYbc6pvrlassZhTfbltSImjKO6G4bn9BhLgakHrAKp7g68r5GS
 zSFy4HGLVNG2SFqWD/ay3dG2MCe93kTlXRDesAh+McEO7hhOLW
 1jVJ4TeAS6OH4NDgwx/k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 22:02:01 Stefan Agner wrote:
> On 2014-11-28 17:49, Arnd Bergmann wrote:
> > On Friday 28 November 2014 17:43:35 Stefan Agner wrote:
> >> Support Vybrid SoC's system reset controller (SRC). Currently we
> >> don't register a reset controller but only support the imx_cpu_jump
> >> and imx_cpu_arg functions.
> >>
> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> > 
> > I think this should be a platform driver in drivers/power/reset.
> 
> Yeah, I thought that too, see my cover letter. The problem is, in that
> module are also some register which are of interest when implementing
> suspend/resume support (see cover letter too). However, we could also
> just make a dt entry for that reset register only, and create another dt
> entry for the other registers.

Don't make a node with just one register, in this case, a syscon device
would be best.

> > If the SRC is also capable of resetting individual blocks instead of just
> > the entire machine, it would be a reset driver in drivers/reset instead.
> 
> Beside the system reset, there is only a mask functionality for the
> watchdogs (there are two watchdogs, one for Cortex-A5 and one for the
> M4). This makes the SRC module in the Vybrid a bit different then what
> is available on other i.MX SoC's...

If you already have the watchdog registers in there and want to have
a watchdog driver too, the easiest way would be to register the reboot
handler from the watchdog driver.

	Arnd
