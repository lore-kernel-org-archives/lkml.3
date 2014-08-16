Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaHPQWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 12:22:55 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41959 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaHPQWy (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 12:22:54 -0400
Message-ID: <53EF8559.7010103@gmail.com>
Date: Sat, 16 Aug 2014 18:22:49 +0200
From: Philippe Reynes <tremyfr@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120623 Thunderbird/10.0.5
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: linux-kernel <Linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Peter Chen <Peter.Chen@freescale.com>,
        gwenhael.goavec-merou@trabucayre.com
Subject: Re: [RFC] usb issue on imx27: 3 clocks are needed
References: <53EF7AF6.2000405@gmail.com> <CAOMZO5CSGUp5qsgtDtqdoVq69EGmxV=quDD0CBSvHiOL5JNiwg@mail.gmail.com>
In-Reply-To: <CAOMZO5CSGUp5qsgtDtqdoVq69EGmxV=quDD0CBSvHiOL5JNiwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,


On 16/08/14 18:01, Fabio Estevam wrote:
> Hi Philippe,
>
> On Sat, Aug 16, 2014 at 12:38 PM, Philippe Reynes<tremyfr@gmail.com>  wrote:
>> Hi all,
>>
>> i.MX27's usb needs three clocks (usb_ipg_gate, usb_ahb_gate and usb_div)
>> but the current chipidea driver implementation, and devicetree, provides
>> only ipg and ahb. Consequently, if the bootloader don't enable the last
>> one, the kernel will crash.
>
> Which kernel version and what is the crash log you are getting?

I use linux git kernel (from linus) and 3.16.
Both has the same result, a crash in the function hw_phymode_configure.
  
> I used to get a USB crash on mx27, which was fixed with the following commit:
>
> commit b67b19447eb4f60d4f004f48298154630d4bed39
> Author: Fabio Estevam<fabio.estevam@freescale.com>
> Date:   Wed Apr 16 14:53:18 2014 -0300
>
>      ARM: dts: imx27: Use the correct usb clock gate
>
>      USB Host1, Host2 and OTG are gated via 'usb_ipg_gate' clock, so
> fix it in order
>      to avoid the following kernel oops:
>
>      usbcore: registered new interface driver usb-storage
>      10024000.usb supply vbus not found, using dummy regulator
>      Unhandled fault: external abort on non-linefetch (0x808) at 0xf4424184
>      Internal error: : 808 [#1] PREEMPT ARM
>      Modules linked in:
>      CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc1-26325-g971f9fd-dirty #64
>      task: c7829aa0 ti: c7836000 task.ti: c7836000
>      PC is at ci_hdrc_probe+0x3a4/0x634
>      LR is at ci_hdrc_probe+0x100/0x634
>      pc : [<c036cc78>]    lr : [<c036c9d4>]    psr: 60000013
>      sp : c7837d48  ip : 00000001  fp : 00000000
>      r10: 00000000  r9 : 00000000  r8 : c791b6c0
>      r7 : c7945000  r6 : f4424000  r5 : c7945010  r4 : c794e010
>      r3 : f4424184  r2 : 00000000  r1 : 8c000004  r0 : 0c000004
>      Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
>      Control: 0005317f  Table: a0004000  DAC: 00000017
>      Process swapper (pid: 1, stack limit = 0xc78361c0)
>      Stack: (0xc7837d48 to 0xc7838000)
>
>      Signed-off-by: Fabio Estevam<fabio.estevam@freescale.com>
>      Signed-off-by: Shawn Guo<shawn.guo@freescale.com>
>
> Do you have this one applied?

Yes, I've got this commit on my kernel.

This patch enable clock ipg, but the clock usb_div is disable,
so the "crash" still happen. The only way we found to get the
usb working is to enable the three usb clock : ipg, ahb and per.

Best regards,
Philippe
