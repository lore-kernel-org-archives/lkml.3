Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3A1J74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:59:56 -0500
Received: from sestofw01.enea.se ([192.36.1.252]:7680 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751390Ab3A1J7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:59:54 -0500
From: Mats Liljegren <mats.liljegren@enea.com>
To: Nishanth Menon <menon.nishanth@gmail.com>,
        Paolo Pisati <p.pisati@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: RE: [BUG] panda board locks up on boot
Thread-Topic: [BUG] panda board locks up on boot
Thread-Index: AQHN+qjAni9YP6Nib0GW0m1VMtmgd5hZj/EAgAAj6PCAA3bdAIAABd4AgAFV1tA=
Date: Mon, 28 Jan 2013 09:59:47 +0000
Message-ID: <0247700D01F14443B9209F90AD938CC524099EA3@sestoex09.enea.se>
References: <1359082886.21576.199.camel@gandalf.local.home>
 <51022FD2.8090101@compulab.co.il>
 <0247700D01F14443B9209F90AD938CC52409708C@sestoex09.enea.se>
 <20130127141254.GC5714@stinkpad> <51053AD2.8080805@gmail.com>
In-Reply-To: <51053AD2.8080805@gmail.com>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.140.67]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nishanth Menon [mailto:menon.nishanth@gmail.com]
> Sent: den 27 januari 2013 15:34
> To: Paolo Pisati
> Cc: Mats Liljegren; Tony Lindgren; LKML; Steven Rostedt; Igor Grinberg;
> Russell King; Venkatraman S; linux-arm-kernel; linux-omap
> Subject: Re: [BUG] panda board locks up on boot
> 
> On 01/27/2013 08:12 AM, Paolo Pisati wrote:
> > On Fri, Jan 25, 2013 at 08:43:15AM +0000, Mats Liljegren wrote:
> >> Hi Steven,
> >>
> >> Do you have CONFIG_CPU_FREQ enabled? As I posted earlier in linux-
> kernel forum ("Failed booting PandaBoard ES with Linux 3.8 RC4" two days
> ago) my PandaBoard ES hangs while booting with this option enabled. It
> works fine without it. I have not bisected it down to a single commit though.
> >
> > glad i'm not the only one who hit this problem:
> >
> > "3.8rc4+ and cpu_freq omap: hangs, oopses, etcetc"
> >
> > http://www.mail-archive.com/linux-
> omap@vger.kernel.org/msg83693.html
> >
> 
> Support for TPS is not yet in mainline kernel. you may want to do:
> 
> you could try running 'mw.w 0x4A31E05A 0x1' before bootm in u-boot -> This
> will hack the pad of panda ES pin mean for controlling TPS voltage register
> (again a kernel bug where the GPIO block setup by bootloader got reset).
> 
> CPUfreq needs both voltage and frequency scaling to work and without
> support of the TPS voltage scaling on vdd_MPU, you are stuck at boot
> voltage, and just scaling frequency. with the not-enough boot voltage,
> moving to higher frequencies can/will result in unpredictable behavior.
> 
> ---
> Regards,
> NM

Thanks for the suggestion. Unfortunately it didn't make any difference for me, neither did an upgrade to 3.8-rc5. I guess I have to wait for the TPS support to hit mainline kernel.

Regards
Mats

