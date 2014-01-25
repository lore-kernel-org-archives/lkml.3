Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaAYVIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:08:24 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:48429 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaAYVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:08:22 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21220.10175.311714.796806@gargle.gargle.HOWL>
Date: Sat, 25 Jan 2014 22:08:15 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ia64 ski emulator patches
In-Reply-To: <alpine.LRH.2.02.1401251536550.27200@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
	<21218.28095.779306.523187@gargle.gargle.HOWL>
	<alpine.LRH.2.02.1401240937020.28468@file01.intranet.prod.int.rdu2.redhat.com>
	<21219.63903.326798.277717@gargle.gargle.HOWL>
	<alpine.LRH.2.02.1401251536550.27200@file01.intranet.prod.int.rdu2.redhat.com>
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka writes:
 > 
 > 
 > On Sat, 25 Jan 2014, Mikael Pettersson wrote:
 > 
 > > My ski patches are in <http://user.it.uu.se/~mikpe/linux/patches/ia64/ski-1.3.2/>
 > > for now.  I'll post the kernel patches to linux-ia64 @ vger in a few minutes.
 > > 
 > > /Mikael
 > 
 > Thanks for the patches.
 > 
 > Isn't this subject to races? - could it lock up if the signal happens just 
 > before the pause syscall?
 > 
 > +    case SSC_HALT_LIGHT:
 > +      /* Sleep until SIGIO or SIGALRM is received; this relies on
 > +        keyboard/ethernet input being detected via SIGIO, and the
 > +        ITC now being emulated via setitimer() and SIGALRM.  */
 > +      pause ();
 > +      break;
 > +

Thanks for the review. You're right, the pause mustn't happen if
itc_itimer_fired == 1.  Let me ponder this for a while...

/Mikael
