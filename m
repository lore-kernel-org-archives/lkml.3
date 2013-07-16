Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3GPJcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:32:45 -0400
Received: from p-mail2.rd.orange.com ([195.101.245.16]:57907 "EHLO
	p-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3GPJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:32:43 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new streaming format
Date: Tue, 16 Jul 2013 11:32:39 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.10-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <201307161112.17901.yann.morin.1998@free.fr> <20130716092242.GD4402@pd.tnic>
In-Reply-To: <20130716092242.GD4402@pd.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307161132.39845.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 16 Jul 2013 09:32:40.0210 (UTC) FILETIME=[6A6AF720:01CE8207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav, All,

On Tuesday 16 July 2013 11:22:42 Borislav Petkov wrote:
> On Tue, Jul 16, 2013 at 11:12:17AM +0200, Yann E. MORIN wrote:
> > The goal is to avoid generating a non-buildable kernel in the first place.
> 
> I know, that's why I'm proposing to fail the build with the script run
> as one of the first things by make.

No, this is already too late: the given .config *is* already broken and
unbuildable.

> > > I.e., those steps:
> > > 1. make <whatever>config
> > > 2. make => A prereq. target runs the shell script.
> > 
> > This is too late, since this will bail out, and will give a false-positive
> > failure.
> 
> Huh? This will tell you: "you've selected X, but I don't have toolX
> needed for the build".
> 
> You install the tool and run make again. Checks pass, the build
> continues.

That does not work in two cases:
  - older distros that do not have the tool packaged
  - automatic test-harness that run thousands of randconfig a day

In the first case, this /could/ be overcome by the user compiling and
installing the package manually, but is mostly undoable in enterprise
environment with shared build machines, where each user would have to
install the same tool(s) again and again.

In the second case, this would yield a lot of false-positive in daily
reports.

Your solution mostly works with minimum overhead for a human user
interactively building a kernel, not with automated test harnesses.

> > While if we were to check for _known_ needed tools before calling into
> > Kconfig,
> 
> How would you do that? How do you know what the user is going to select
> *before* she even selects it?

The idea is to *avoid* the user being able to select unavailable options.

> You need to have a prepared .config to act upon.

The idea is to be always have a .config that is buildable with the current
toolset of the system, especially for esoteric and/or recent tools that are
not packaged and/or installed by default by the distros.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
