Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaJ1O3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:29:17 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57515 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaJ1O3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:29:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] ARM: use early console instead of early debug in allmodconfig kernels
Date: Tue, 28 Oct 2014 15:29:01 +0100
Message-ID: <3063784.TXO37ZkrnY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141028140536.GF27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org> <1414503095-25986-6-git-send-email-kaixu.xia@linaro.org> <20141028140536.GF27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pbJWTlitzx+rVV7tPA0bT6dnrHLJu4E6Ke+r9oN/OQ+
 HXvjj+SVD0xfvgD2gooXI4fJwHRxTUYxYuJfb1ZjA3C5xSwKdt
 adYBuIr+r8fg2exvpyu2wSF8Ti3m6Dxvln0f9nnXCXhvNkwiRb
 pA9YE4BOILAMyJvWStgLHFVarhB0i9merTdYTb0B1A0fcRsorL
 3WYyyFLxiIb6ttd6XwZV+eGCsFCpYE4UlChaNk26t4PVVVWWhs
 U64CWPe5nbf5rMyCPZ2F4cUUeE8bbPoK3YMn7P7qFcD/tGGAd8
 F34GAXJ4wLSt0TUfOjrofAli4o89F2uuQ0KekCM775Htk/Jizy
 Q8kVBoF5vT8pkkL5GR3Q=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 14:05:36 Russell King - ARM Linux wrote:
> On Tue, Oct 28, 2014 at 09:31:35PM +0800, Xia Kaixu wrote:
> > The early debug could break something when booting 'allmodconfig'
> > kernels. So we use early console instead of early debug.
> > 
> > The early console didn't work yet on OMAP4460 because of missing
> > earlycon support and I am working on that.
> 
> No. bloody. way.
> 
> > @@ -78,7 +78,7 @@ config DEBUG_USER
> >  # These options are only for real kernel hackers who want to get their hands dirty.
> >  config DEBUG_LL
> >       bool "Kernel low-level debugging functions (read help!)"
> > -     depends on DEBUG_KERNEL
> > +     depends on DEBUG_KERNEL && !ARCH_MULTIPLATFORM_STRICT
> 
> Firstly, this is well advertised that it can only be applied to a single
> configuration.  So I don't think we need this dependency here.  Even if
> you want to build a strict multiplatform kernel, it should still be
> possible to enable this for a specific platform.

I've asked Kaixu to do this patch. This is one of the most fundamental
uses of ARCH_MULTIPLATFORM_STRICT: as soon as you turn on DEBUG_LL, the
kernel no longer runs on any other platform, so it can still be built
as a multiplatform kernel, but not a "strict" one that is known to
work on all hardware that is enabled.
 
> It's a developer option, one which requires the developer to engage their
> brain before using.

Exactly, and I think it's not asking too much from a developer to turn
off ARCH_MULTIPLATFORM_STRICT if they want to turn on DEBUG_LL. Nothing
else should change if you do that.

The main use of the symbol is really to avoid turning on DEBUG_LL is
allmodconfig kernels, which will always enable ARCH_MULTIPLATFORM_STRICT.

	Arnd
