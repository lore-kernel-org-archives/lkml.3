Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaJTTAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:00:55 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:61750 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaJTTAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:00:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz,
        Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@linaro.org>,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        Ramkumar Ramachandra <artagnon@gmail.com>, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com,
        Orson Zhai <orsonzhai@gmail.com>, geng.ren@spreadtrum.com,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 2/6] arm64: Add DTS support for Spreadtrum's Shark64 SoC
Date: Mon, 20 Oct 2014 21:00:19 +0200
Message-ID: <1799842.6CvQjvbUTo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAfSe-tPynLarYRzsTw3vncp8CB0EnoaR_Z6tPQNA7DEV7+w9Q@mail.gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com> <4004425.NZAxCnE0qr@wuerfel> <CAAfSe-tPynLarYRzsTw3vncp8CB0EnoaR_Z6tPQNA7DEV7+w9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:b4eCDtJ0IdMNryxJH301ZDqV3CPzuz4HeL+EFxzjIQr
 M41dB4qrO87UYi5qnXy0ao+AdIo3KTq95MpxN5nBnDh8mULED0
 X9a0vQ3swzG2v0VXmdgUECsksDa6CmX+J9ukTxPUTts3VRp/wC
 kRLEha49SdpGtXrII819A/OQg50QrZjnGDraQ8xS/YNTGMthJP
 9l+r0zC2d96ZkD6tv81EQsUhhjX7ulM1dM3g+3P9MC9z5QPMFK
 32xkBEwDGjNmWW5vZk3fUZXyqhlJHEBrjbtlp5X286n0lF/6hQ
 sA6SlAOXe8M0iTIpTVvLs84sIfweSlrhumAAOOCoQDIIFVekYy
 8ln+u9z14/ceCb8gp5do=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2014 11:17:07 Lyra Zhang wrote:
> Hi, Arnd

Hi Lyra,

Sorry for the late reply, I've been away travelling and am just
now catching up on email. Have you found a solution or do
you still need help with this?

	Arnd

> 2014-09-29 21:47 GMT+08:00 Arnd Bergmann <arnd@arndb.de>:
> > On Monday 29 September 2014 20:04:49 zhang.lyra@gmail.com wrote:
> >> +
> >> +/memreserve/ 0x80000000 0x00010000;
> >
> > Maybe add a comment explaining why it is reserved?
> >
> >> +     chosen {
> >> +             bootargs = "earlycon=serial_sprd,0x70000000";
> >> +      };
> >
> > Just remove this for now, the command line should really be set by the
> > boot loader, not hardcoded in the dts file.
> >
> > IIRC, the earlycon=... syntax is not recommended on DT based systems,
> > better use the "stdout-path" syntax instead.
> >
> 
> I have tried to use  "stdout-path" instead of "bootargs= "earlycon=
> ..." like below :
> 
> / {
>      ...
> 
>      chosen {
>              stdout-path = "/serial@70000000";
>       };
> 
>      uart0: serial@70000000 {
>              status="okay";
>      };
>       ...
> };
> 
> But then there is nothing output information on serial console.(I have
> been testing in Fast Model)
> 
> 
> I saw the below code in init/main.c
> 
> /* Check for early params. */
> static int __init do_early_param(char *param, char *val, const char *unused)
> {
> const struct obs_kernel_param *p;
> 
> for (p = __setup_start; p < __setup_end; p++) {
> if ((p->early && parameq(param, p->str)) ||
>    (strcmp(param, "console") == 0 &&
>     strcmp(p->str, "earlycon") == 0)
> ) {
> if (p->setup_func(val) != 0)
> pr_warn("Malformed early option '%s'\n", param);
> }
> }
> /* We accept everything at this stage. */
> return 0;
> }
> 
> And I saw a patch from Grant Likely, he had a comment in it :
> "If the devicetree specifies a serial port as a stdout device, then the
> kernel can use it as the default console if nothing else was selected on
> the command line. For any serial port that uses the uart_add_one_port()
> feature, the uart_add_one_port() has all the information needed to
> automatically enable the console device, which is what this patch does."
> 
> So, I guess that the reason why I can't see any output information on
> console after using "stdout-path" instead of "earlycon" is that I
> haven't a driver of Spreadtrum's serial, and dose not use  the
> uart_add_one_port() feature.
> 
> I don't know is correct what I guess.
> 
> Could you give me some suggestions to solve this problem?
> 

