Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3A0OeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:34:05 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51600 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3A0Od6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:33:58 -0500
Message-ID: <51053AD2.8080805@gmail.com>
Date: Sun, 27 Jan 2013 08:33:54 -0600
From: Nishanth Menon <menon.nishanth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paolo Pisati <p.pisati@gmail.com>
CC: Mats Liljegren <mats.liljegren@enea.com>, Tony Lindgren <tony@atomide.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [BUG] panda board locks up on boot
References: <1359082886.21576.199.camel@gandalf.local.home> <51022FD2.8090101@compulab.co.il> <0247700D01F14443B9209F90AD938CC52409708C@sestoex09.enea.se> <20130127141254.GC5714@stinkpad>
In-Reply-To: <20130127141254.GC5714@stinkpad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 08:12 AM, Paolo Pisati wrote:
> On Fri, Jan 25, 2013 at 08:43:15AM +0000, Mats Liljegren wrote:
>> Hi Steven,
>>
>> Do you have CONFIG_CPU_FREQ enabled? As I posted earlier in linux-kernel forum ("Failed booting PandaBoard ES with Linux 3.8 RC4" two days ago) my PandaBoard ES hangs while booting with this option enabled. It works fine without it. I have not bisected it down to a single commit though.
>
> glad i'm not the only one who hit this problem:
>
> "3.8rc4+ and cpu_freq omap: hangs, oopses, etcetc"
>
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg83693.html
>

Support for TPS is not yet in mainline kernel. you may want to do:

you could try running 'mw.w 0x4A31E05A 0x1' before bootm in u-boot -> 
This will hack the pad of panda ES pin mean for controlling TPS voltage 
register (again a kernel bug where the GPIO block setup by bootloader 
got reset).

CPUfreq needs both voltage and frequency scaling to work and without 
support of the TPS voltage scaling on vdd_MPU, you are stuck at boot 
voltage, and just scaling frequency. with the not-enough boot voltage, 
moving to higher frequencies can/will result in unpredictable behavior.

---
Regards,
NM
