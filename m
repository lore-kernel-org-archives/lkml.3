Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbbA1VsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:48:00 -0500
Received: from smtp2.ore.mailhop.org ([54.186.57.195]:59378 "EHLO
	smtp2.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbbA1UeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:34:04 -0500
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX1+vZeKRQhoSvsL4y/9TBMEz
Date: Wed, 28 Jan 2015 07:48:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150128154824.GM28663@atomide.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr>
 <20150128153912.GL28663@atomide.com>
 <201501281647.34477@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201501281647.34477@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [150128 07:50]:
> On Wednesday 28 January 2015 16:39:13 Tony Lindgren wrote:
> > * Nicolas Pitre <nico@fluxnic.net> [150128 06:37]:
> > > On Wed, 28 Jan 2015, Pali Rohár wrote:
> > > > On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
> > > > > On omaps, the bootrom passes the bootreason in r1 to the
> > > > > bootloader that can do whatever it wants with it. We
> > > > > could maybe pass it in the kernel cmdline to the
> > > > > watchdog driver for user space?
> > > > 
> > > > Not truth for N900. Bootreason depends on PRM_RSTST omap
> > > > register, state of vbat charger pins, time how long was
> > > > power key pressed, R&D data stored in CAL partition and
> > > > other undocumented registers for omap HS devices. I
> > > > already tried to implement at least some subset of it in
> > > > userspace (or kernel), but it is impossible because NOLO
> > > > bootloader clear status of PRM_RSTST register.
> > > > 
> > > > There is also copy of PRM_RSTST register stored at address
> > > > 0x4020FFB8 (tracing data) but that address is rewritten
> > > > (probably by kernel), so we really cannot implement
> > > > reading bootreason in kernel.
> > > > 
> > > > But in early stage in uboot it is possible to read
> > > > 0x4020FFB8 address and get some part of bootreason. But
> > > > still PRM_RSTST is not enough!
> > > > 
> > > > I would be happy if DT kernel can export /proc/atags file
> > > > with ATAGs passed by bootloader. It would be enough for
> > > > me. In userspace I can parse content and do what is
> > > > needed.
> > > 
> > > What about defining a DT boot reason property instead?
> > > Maybe it already exists?  If not, it's something that could
> > > certainly be generically used on other platforms too.
> > > 
> > > Converting the special ATAG into its standard DT equivalent
> > > would then be trivial and much cleaner overall.
> > 
> > Sounds good to me as then we don't have to add any legacy
> > custom Nokia specific atag. And it won't prevent us from
> > adding a generic ATAG_BOOTREASON if really needed.
> 
> And what would new atag ATAG_BOOTREASON solve for Nokia N900? 
> Nothing.

Right, so probably no need to add it then :) But what Nico is
saying we can translate the Nokia custom bootreason to a
standard DT property if I'm reading right.

Regards,

Tony
