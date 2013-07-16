Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3GPJpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:45:33 -0400
Received: from p-mail1.rd.orange.com ([195.101.245.15]:24579 "EHLO
	p-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3GPJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:45:32 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new streaming format
Date: Tue, 16 Jul 2013 11:45:27 +0200
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
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <201307161132.39845.yann.morin.1998@free.fr> <20130716093820.GE4402@pd.tnic>
In-Reply-To: <20130716093820.GE4402@pd.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307161145.27810.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 16 Jul 2013 09:45:28.0159 (UTC) FILETIME=[3426AEF0:01CE8209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav, All,

On Tuesday 16 July 2013 11:38:20 Borislav Petkov wrote:
> On Tue, Jul 16, 2013 at 11:32:39AM +0200, Yann E. MORIN wrote:
> > That does not work in two cases:
> >   - older distros that do not have the tool packaged
> 
> This point is moot - distro kernels are built by the distro people.

It's not about building distro kernels. It's about building the current
kernel on a distro, for example for cross-compilation.

> >   - automatic test-harness that run thousands of randconfig a day
> randconfigs are not guaranteed to build successfully.

Well, mostly agreed. However, there was a request (in this thread) that
using such new tools that are not yet widely available in distros, does
not break randconfig.

This is a *new* requirement.

> > The idea is to be always have a .config that is buildable with the
> > current toolset of the system, especially for esoteric and/or recent
> > tools that are not packaged and/or installed by default by the
> > distros.
> How are you going to tell the user running make <something>config to
> install the missing tools?

As discussed with Florian in this thread, either one of:
  - a warning at check time
  - a comment in Kconfig

which both are easy enough to achieve. As I said earlier in this thread,
I've been using a similar scheme in crosstool-NG (which uses Kconfig as
its configuration infrastructure), and it has been proven effective
over the past feew years.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
