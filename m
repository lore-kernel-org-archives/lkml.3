Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaKPMQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:16:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:57962 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaKPMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:16:43 -0500
Date: Sun, 16 Nov 2014 13:16:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141115024042.GA18015@redhat.com>
Message-ID: <alpine.DEB.2.11.1411161314060.3909@nanos>
References: <20141114213124.GB3344@redhat.com> <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com> <alpine.DEB.2.11.1411142326510.3909@nanos> <20141114233213.GA14135@redhat.com> <alpine.DEB.2.11.1411150119070.3909@nanos>
 <20141115024042.GA18015@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Dave Jones wrote:
> On Sat, Nov 15, 2014 at 01:36:41AM +0100, Thomas Gleixner wrote:
>  > On Fri, 14 Nov 2014, Dave Jones wrote:
>  > 
>  > > On Fri, Nov 14, 2014 at 11:55:30PM +0100, Thomas Gleixner wrote:
>  > >  
>  > >  > So this looks more like a smp function call fuckup.
>  > >  > 
>  > >  > I assume Dave is running that stuff on KVM. So it might be worth while
>  > >  > to look at the IPI magic there.
>  > > 
>  > > no, bare metal.
>  > 
>  > Ok, but that does not change the fact that we are stuck in
>  > smp_function_call land.
>  > 
>  > Enabling softlockup_all_cpu_backtrace will probably not help much as
>  > we will end up waiting for csd_lock again :(
>  > 
>  > Is the machine still accesible when this happens? If yes, we might
>  > enable a few trace points and functions and read out the trace
>  > buffer. If not, we could just panic the machine and dump the trace
>  > buffer over serial.
> 
> No, it wedges solid. Even though it says something like "CPU3 locked up",
> aparently all cores also get stuck.

Does not surprise me. Once the smp function call machinery is wedged...

> 9 times out of 10 it doesn't stay alive long enough to even get the full
> trace out over usb-serial.

usb-serial is definitely not the best tool for stuff like this. I
wonder whether netconsole might give us some more info.

Last time I looked into something like that on my laptop I had to
resort to a crash kernel to get anything useful out of the box.

Thanks,

	tglx
