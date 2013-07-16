Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3GPJMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:12:24 -0400
Received: from p-mail1.rd.orange.com ([195.101.245.15]:35133 "EHLO
	p-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3GPJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:12:22 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new streaming format
Date: Tue, 16 Jul 2013 11:12:17 +0200
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
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <20130716012756.31936d8d.akpm@linux-foundation.org> <20130716090546.GB4402@pd.tnic>
In-Reply-To: <20130716090546.GB4402@pd.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307161112.17901.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 16 Jul 2013 09:12:18.0728 (UTC) FILETIME=[925B9A80:01CE8204]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav, All,

On Tuesday 16 July 2013 11:05:46 Borislav Petkov wrote:
> On Tue, Jul 16, 2013 at 01:27:56AM -0700, Andrew Morton wrote:
> > What I'm angling at is, rather than a single global front-end script,
> > can we embed the scripts in some fashion within the various Kconfig
> > files?  Say,
> > 
> > 	script ./some-script.sh
> > 
> > and the config system will only evaluate that command if it is working
> > on that Kconfig file.  Obviously that requires a multiple-pass thing.
> 
> What's wrong with simply grepping the .config we've just created for
> *enabled* symbols which require userspace support, check for the
> presence of said support and bail out if none?

The goal is to avoid generating a non-buildable kernel in the first place.
This is very usefull for automatic check harness that run randconfig, for
example (but may have more use-cases).

> I.e., those steps:
> 1. make <whatever>config
> 2. make => A prereq. target runs the shell script.

This is too late, since this will bail out, and will give a false-positive
failure.

While if we were to check for _known_ needed tools before calling into
Kconfig, we can simply hide non-available config options, and even inform
the user *why* the option is not available.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
