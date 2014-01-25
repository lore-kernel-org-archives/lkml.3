Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaAYSDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:03:06 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61447 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaAYSDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:03:05 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21219.64595.865681.816488@gargle.gargle.HOWL>
Date: Sat, 25 Jan 2014 19:02:59 +0100
To: "Luck\, Tony" <tony.luck@intel.com>
Cc: Mikael Pettersson <mikpelinux@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Yu\, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64\@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] ia64 ski emulator patches
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31DB8B73@ORSMSX106.amr.corp.intel.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
	<21218.28095.779306.523187@gargle.gargle.HOWL>
	<3908561D78D1C84285E8C5FCA982C28F31DB8B73@ORSMSX106.amr.corp.intel.com>
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony writes:
 > Mikulas:
 > >> Here I'm sending some ia64 patches to make it work in the ski emulator. 
 > >> This has been broken for a long time.
 > 
 > Thanks - There are questions from time to time on how to test ia64
 > for those people who do not have hardware.
 > 
 > Mikael:
 > > Thanks.  I've recently started running 3.x kernels on ia64 via ski,
 > > but I'm getting random kernel crashes with 3.13.  I'll give your
 > > patches a try shortly.
 > 
 > Let me know how that goes - I haven't used ski in a decade and
 > have quite forgotten how to set it up.

It seems my kernel crashes were due to using gcc-4.8.2 to compile ski,
going back to gcc-4.7.3 for ski, and gcc-4.3.6 for cross-compiling
the kernel, gives me a solid emulated system.

 > > I've written a few patches to improve other aspects of running the
 > > kernel on ski:
 > > - kernel patch to turn PAL_HALT_LIGHT into a new SSC_HALT_LIGHT,
 > >   and a corresponing ski patch to pause() on SSC_HALT_LIGHT; this
 > >   together with the fixed-frequency ITC patch allows ski to idle
 > >   with very low host CPU overhead when the guest kernel idles
 > > - kernel patch to bump the RAM size from 130MB to 2GB
 > >
 > > I'd be happy to share these patches if there's interest in them.
 > 
 > It seems that there are at least two of you out there - so I'm happy
 > to take kernel patches that make things better.  Not sure where the
 > ski patches go - is someone maintaining that?

The ski project on sourceforge seems dead, nothing have been posted
on its mailing list since 2008, and the web interface for browsing
the source repo is broken.  Red Hat, Gentoo, and Debian package ski
with a few common build fixes, but that's it.

/Mikael
