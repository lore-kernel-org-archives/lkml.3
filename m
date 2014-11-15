Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaKOCk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 21:40:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbaKOCk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 21:40:56 -0500
Date: Fri, 14 Nov 2014 21:40:42 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141115024042.GA18015@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <alpine.DEB.2.11.1411142326510.3909@nanos>
 <20141114233213.GA14135@redhat.com>
 <alpine.DEB.2.11.1411150119070.3909@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411150119070.3909@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 01:36:41AM +0100, Thomas Gleixner wrote:
 > On Fri, 14 Nov 2014, Dave Jones wrote:
 > 
 > > On Fri, Nov 14, 2014 at 11:55:30PM +0100, Thomas Gleixner wrote:
 > >  
 > >  > So this looks more like a smp function call fuckup.
 > >  > 
 > >  > I assume Dave is running that stuff on KVM. So it might be worth while
 > >  > to look at the IPI magic there.
 > > 
 > > no, bare metal.
 > 
 > Ok, but that does not change the fact that we are stuck in
 > smp_function_call land.
 > 
 > Enabling softlockup_all_cpu_backtrace will probably not help much as
 > we will end up waiting for csd_lock again :(
 > 
 > Is the machine still accesible when this happens? If yes, we might
 > enable a few trace points and functions and read out the trace
 > buffer. If not, we could just panic the machine and dump the trace
 > buffer over serial.

No, it wedges solid. Even though it says something like "CPU3 locked up",
aparently all cores also get stuck.
9 times out of 10 it doesn't stay alive long enough to even get the full
trace out over usb-serial.

	Dave

