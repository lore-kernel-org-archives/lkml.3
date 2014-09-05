Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaIEQ0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:26:31 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58401 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIEQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:26:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Robert Richter <rric@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        Olof Johansson <olof@lixom.net>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family
Date: Fri, 05 Sep 2014 18:25:35 +0200
Message-ID: <2952834.1P42roDKD9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140905142245.GG20164@leverpostej>
References: <1409903205-2762-1-git-send-email-rric@kernel.org> <7863371.EMkUuntQWU@wuerfel> <20140905142245.GG20164@leverpostej>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:eAfxoXawJooWUFiqSRYp7hCztEFVCe23J4csNaYjMCa
 bhBny7xcWuZ7ZI3fqmW11EL6z8XlQkYqG+AHlsBTrPZPiAEQ/v
 Rcqr9R3PK7rW61cIgYvG1p0PMt1pwwS7FCz5sRPrY5I//xrNZC
 1cXWsufp1b+QCKeOMHUZYxuknqOs+GGq2n1cMT9d/EDL9Ao3fA
 CJ2thaDrZAxjzmcbPGfMNnGCj/nPeIsEAt6wvejSP4BrYZpc2U
 KFNCCZnT0M9e+mYHMPv5XE/JT5QN8BmufLD3ZJQLMaetH0bTfu
 3QeZLzAeaS5u6QlEEoK+tz9hR0t/w9qJJkqEAe1OOc8MYZ7t+2
 0vIasfSg+RDmMHz3ufPQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 15:22:46 Mark Rutland wrote:
> 
> > A common pattern these days is to do dependencies like
> > 
> > arch/*/Kconfig:
> >       config ARCH_FOO
> >       bool "Enable support for Foo platform"
> >       help
> >         ...
> > 
> > 
> > drivers/*/Kconfig
> >       config SUBSYS_FOO
> >       bool "SUBSYS driver for Foo"
> >       depends on ARCH_FOO || COMPILE_TEST
> >       depends on OF && REGULATOR && GENERIC_PHY # or whatever
> 
> Russell's comments w.r.t. Kconfig warnings when config names change
> still holds regardless of select vs depends on.

Yes, that's what I wrote in my reply as well.

> > That way we can enable everything in the defconfig, but someone
> > who likes to build a more specialized kernel can disable the
> > other platforms and won't get the drivers that are specific to
> > those.
> > 
> > I personally think this is a bit more verbose than what we need, but
> > I don't strongly object doing it that way.
> 
> You'd still be able to do this without ARCH_FOO, though you would need
> to know which drivers are necessary for a particular SoC. That seems to
> be the way things are handled on x86; I don't recall having to select
> support for specific machines there, just the individual drivers.

The main difference is that there are very few drivers on x86 that are
specific to one of the two chip makers. Almost everything is a PCI
device that can actually be plugged in anywhere.

On ARM64 there is going to be a lot of stuff that really makes sense
only for one of the 50 licensees.

	Arnd
