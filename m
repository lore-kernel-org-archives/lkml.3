Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3FJNgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:36:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64351 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3FJNgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:36:15 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 10 Jun 2013 06:37:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>, Michael Neuling <mikey@neuling.org>
Subject: Re: Linux 3.9.5
Message-ID: <20130610133702.GA29579@roeck-us.net>
References: <20130607195816.GA28479@kroah.com>
 <20130608035312.GA16419@roeck-us.net>
 <20130608140817.GA7303@kroah.com>
 <20130608144237.GA21423@roeck-us.net>
 <CA+5PVA5qoTspk6idt4-9U9e2X=Nt_mOi6LPEiRb3hEUFLSWmjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5qoTspk6idt4-9U9e2X=Nt_mOi6LPEiRb3hEUFLSWmjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 08:10:11AM -0400, Josh Boyer wrote:
> On Sat, Jun 8, 2013 at 10:42 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Sat, Jun 08, 2013 at 07:08:17AM -0700, Greg KH wrote:
> >> On Fri, Jun 07, 2013 at 08:53:12PM -0700, Guenter Roeck wrote:
> >> > On Fri, Jun 07, 2013 at 12:58:16PM -0700, Greg KH wrote:
> >> > > I'm announcing the release of the 3.9.5 kernel.
> >> > >
> >> > > All users of the 3.9 kernel series must upgrade.
> >> > >
> >> > > The updated 3.9.y git tree can be found at:
> >> > >   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> >> > > and can be browsed at the normal kernel.org git web browser:
> >> > >   http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> >> > >
> >> > > thanks,
> >> > >
> >> > > greg k-h
> >> > >
> >> > powerpc build fails:
> >> >
> >> > arch/powerpc/kernel/traps.c: In function 'alignment_exception':
> >> > arch/powerpc/kernel/traps.c:1154:3: error: label 'bail' used but not defined
> >> > make[1]: *** [arch/powerpc/kernel/traps.o] Error 1
> >> > make[1]: *** Waiting for unfinished jobs....
> >> >
> >> > Due to commit 6ce6c629 (powerpc/tm: Abort on emulation and alignment faults).
> >>
> >> Is there a upstream patch that fixes this problem that I should apply?
> >>
> > No, this is not a problem upstream. The missing label was introduced by patch
> > ba12eedee (powerpc: Exception hooks for context tracking subsystem) which, if I
> > understand correctly, was necessary due to 6ba3c97a388 (x86: Exception hooks
> > for userspace RCU extended QS) and a couple of other patches. All that doesn't
> > look like stable material to me.
> 
> This can probably be fixed just by replacing 'goto bail' with 'return'
> on that line.
> Mikey, does that sound right?
> 
I submitted a patch doing just that.

Guenter
