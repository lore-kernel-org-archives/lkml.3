Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaDDQBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:01:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:10928 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753256AbaDDQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:01:10 -0400
Date: Fri, 4 Apr 2014 12:01:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404120106.63db9b0c@gandalf.local.home>
In-Reply-To: <533ED247.9040602@zytor.com>
References: <20140403113921.23dceb75@gandalf.local.home>
	<533D8516.1040803@zytor.com>
	<20140403121314.246b03a7@gandalf.local.home>
	<533DED74.6050202@linux.intel.com>
	<20140403194018.7c67aec7@gandalf.local.home>
	<533DF455.4040908@linux.intel.com>
	<533DF8D2.9060508@zytor.com>
	<533E0A94.5040007@linux.intel.com>
	<20140404151203.GA12370@srcf.ucam.org>
	<533ECC2C.6090505@zytor.com>
	<20140404153634.GA14519@srcf.ucam.org>
	<533ED247.9040602@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2014 08:39:51 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

 
> There are several platforms where the default boot method invokes an SMM
> handler which blithly assumes that the hardware is in whatever state
> Windows leaves it in, and hangs otherwise.  This seems to include nearly
> all Dell systems.  So it isn't really quite that simple...

Just an update. I pulled out of my closet an old Pentium III and got it
to finally boot the new kernel. It reboots fine, but as I left the
printk patch in, it didn't get to the cf9 usage. I take it, it can
detect the level. And perhaps the issues is only with x86_64?

I have no problem with sticking in reboot=b in my development box. I
just wanted people to know that I had issues.

Maybe keep the current way and on reboot, have a pr_info() stating, if
your system doesn't reboot try "reboot=b" on the kernel command line?

-- Steve

