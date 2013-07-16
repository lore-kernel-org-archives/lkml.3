Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3GPJXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:23:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54440 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab3GPJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:23:09 -0400
Date: Tue, 16 Jul 2013 11:22:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
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
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-ID: <20130716092242.GD4402@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <20130716012756.31936d8d.akpm@linux-foundation.org>
 <20130716090546.GB4402@pd.tnic>
 <201307161112.17901.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201307161112.17901.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:12:17AM +0200, Yann E. MORIN wrote:
> The goal is to avoid generating a non-buildable kernel in the first place.

I know, that's why I'm proposing to fail the build with the script run
as one of the first things by make.

> > I.e., those steps:
> > 1. make <whatever>config
> > 2. make => A prereq. target runs the shell script.
> 
> This is too late, since this will bail out, and will give a false-positive
> failure.

Huh? This will tell you: "you've selected X, but I don't have toolX
needed for the build".

You install the tool and run make again. Checks pass, the build
continues.

> While if we were to check for _known_ needed tools before calling into
> Kconfig,

How would you do that? How do you know what the user is going to select
*before* she even selects it?

You need to have a prepared .config to act upon.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
