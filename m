Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaLAPhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:37:31 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50157 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaLAPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:37:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        lee.jones@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, alexandre.torgue@st.com
Subject: Re: [PATCH 0/7] Fix sti drivers whcih mix reg address spaces
Date: Mon, 01 Dec 2014 16:36:51 +0100
Message-ID: <8237128.RmunIxMfYX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416385632-5832-1-git-send-email-peter.griffin@linaro.org>
References: <1416385632-5832-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6blEYnoUbboPI9qPJu70J2rO63r9UFcaPdxRat5reMH
 nd5ZMiyNalgbJLqa1EDLK017W2BigdDy2/xAYgvxqZIJgxtyIz
 9MYQu7NrzFl5vVN0++FK+xw0y5qqi2ovxxpP50LhHG4nEIo81H
 d40x3SWM4A8vAUbTXtB/zITGp3kLGeFa/q4wBD5Z7PM5EY0/R6
 xIXhrNgmqn7X3FGYDclnslf0TsOdbQw8aHnUmHsV/0sCFiKVlj
 zDPSrjAJQFCymEKkbyJLRPAfVN9o6ehZWTLxudHl3vOAm2Nihs
 VLwu0ELT3pwbNb5hhbHUsED6fUJicvA+XRjVdCmh5O2COzuy+d
 7h0BvjA4mFodUeYlAfjw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 08:27:05 Peter Griffin wrote:
> Hi,
> 
> Following on from Arnds comments about the picophy driver here
> https://lkml.org/lkml/2014/11/13/161, this series fixes the
> remaining upstreamed drivers for STI, which are mixing address spaces
> in the reg property. We do this in a way similar to the keystone
> and bcm7445 platforms, by having sysconfig phandle/ offset pair (
> where only one register is required). Or phandle / integer array
> where multiple offsets in the same bank are needed).
> 
> This series breaks DT compatability! But the platform support
> is WIP and only being used by the few developers who are upstreaming
> support for it. I've made each change to the driver / dt doc / dt
> file as a single atomic commit so the kernel will remain bisectable. 
> 
> This series then also enables the picophy driver, and adds back in
> the ehci/ohci dt nodes for stih410 which make use of the picophy.

This all looks very good to me, nice work!

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I have one comment for patch 4, but I don't have a good solution for
that, hopefully someone on the devicetree-discuss list has some insight,
otherwise we just keep your version.

	Arnd
