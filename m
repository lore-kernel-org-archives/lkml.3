Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaAYUlG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 15:41:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbaAYUlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 15:41:04 -0500
Date: Sat, 25 Jan 2014 15:41:00 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mikael Pettersson <mikpelinux@gmail.com>
cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ia64 ski emulator patches
In-Reply-To: <21219.63903.326798.277717@gargle.gargle.HOWL>
Message-ID: <alpine.LRH.2.02.1401251536550.27200@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com> <21218.28095.779306.523187@gargle.gargle.HOWL> <alpine.LRH.2.02.1401240937020.28468@file01.intranet.prod.int.rdu2.redhat.com>
 <21219.63903.326798.277717@gargle.gargle.HOWL>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Jan 2014, Mikael Pettersson wrote:

> My ski patches are in <http://user.it.uu.se/~mikpe/linux/patches/ia64/ski-1.3.2/>
> for now.  I'll post the kernel patches to linux-ia64 @ vger in a few minutes.
> 
> /Mikael

Thanks for the patches.

Isn't this subject to races? - could it lock up if the signal happens just 
before the pause syscall?

+    case SSC_HALT_LIGHT:
+      /* Sleep until SIGIO or SIGALRM is received; this relies on
+        keyboard/ethernet input being detected via SIGIO, and the
+        ITC now being emulated via setitimer() and SIGALRM.  */
+      pause ();
+      break;
+

Mikulas
