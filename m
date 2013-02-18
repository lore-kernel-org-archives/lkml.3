Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3BRFGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:06:00 -0500
Received: from jonshouse.co.uk ([91.84.151.33]:53043 "EHLO
	mail.jonshouse.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3BRFF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:05:59 -0500
Subject: Re: Stupid user with user-space questions, matrix LED driving with
 user space code only.
From: Jonathan Andrews <jon@jonshouse.co.uk>
Reply-To: jon@jonshouse.co.uk
To: Greg KH <gregkh@linuxfoundation.org>
Cc: anish kumar <anish198519851985@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20130218020557.GA27667@kroah.com>
References: <1361025476.4271.36.camel@jonspc>
	 <1361082134.16206.24.camel@anish-Inspiron-N5050>
	 <1361111844.14757.29.camel@jonspc>  <20130218020557.GA27667@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Feb 2013 05:06:08 +0000
Message-ID: <1361163968.29540.62.camel@jonspc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-17 at 18:05 -0800, Greg KH wrote: 
> On Sun, Feb 17, 2013 at 02:37:24PM +0000, Jonathan Andrews wrote:
> > From a user perspective it seems a bit crap to have to change the kernel
> > if you have a workload that preemption is harmful to.  
> > In the case of something like the Raspberry Pi changing the kernel if
> > the distribution has not done the work for me sounds like real effort.
> > The kernel is tied to binary obscurity from broadcom... To build I need
> > a working cross compiler, toolchain, kernel sources, Pi specific patches
> > then to get everything in the correct place on an SD card containing two
> > filesystems.  Its possible but its not going to "just work" at my skill
> > level....
> 
> As you can not boot a kernel.org kernel on the RPI platform just yet,
> there's very little that the kernel.org community can do here to help
> you out.
Somebody could stick in the code to enable/disable preemption at runtime
on PREEMPT compiled kernels :-) - Then all I have to do is wait for it
to filter down to the Raspian kernel maintainers, i'm patient ;-) ?   

In all seriousness I assume preemption has a timer and an interrupt
vector, cant the timer simply be enabled/disabled leaving just the
kernel call mechanism untouched. IE a "preemption" kernel that is now
not preempting ...... OK, OK - I have many other egg sucking suggestions
but am I the only one who wants the functionality ?

Seems a half step to add all this wizzy real-time code to the kernel
then stop users doing real-time in user space by allowing the schedular
to yield during what a user wishes to be a citical section (from a
timing point of view not the atomic point of view).

What about a yield alignment mechanism for user space. IE the process
calls the kernel with a request "schedule me first after a yeild" - then
the process at least has whatever the timer granularity is to do
something timing critical... add a flag to ignore or defer interrupts
and you have a semi 'hard-realtime' behaviour for user space, allowing
user space to grab small chunks of real time. Yes a nasty looking
facility for SMP intel servers but really useful for embedded.

>   I suggest you go take this up with the developers whom you got
> this specific kernel build from, there's nothing we can do here about
> it.
I suspected it was not going to be simple. As I suspect my feature
request is not that simple but if you don't ask........

Thanks,
Jon


