Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946049Ab3FUUkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:40:35 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37863 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945951Ab3FUUke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:40:34 -0400
Date: Fri, 21 Jun 2013 15:40:33 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Robin Holt <holt@sgi.com>,
        Mike Travis <travis@sgi.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
Message-ID: <20130621204032.GA21126@gulag1.americas.sgi.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <CAE9FiQVt7Fa5oTYR+yLsehboPMo86vEDsRUaqNLQD9fizD5=Fg@mail.gmail.com> <51C4A726.1090300@sgi.com> <CAE9FiQWWj8btGK68j6MO1iYwSXiF54h7SqrHCxKwXW5=fnb_0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWWj8btGK68j6MO1iYwSXiF54h7SqrHCxKwXW5=fnb_0A@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 01:28:11PM -0700, Yinghai Lu wrote:
> On Fri, Jun 21, 2013 at 12:19 PM, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > On 06/21/2013 02:10 PM, Yinghai Lu wrote:
> >> in this way we can keep all numa etc on the place when online ram, cpu,
> >> pci...
> >>
> >> For example if we have 32 sockets system, most time for boot is with
> >> *BIOS*
> >> instead of OS. In those kind of system boot is like this way:
> >> only first two sockets get booted from bios to OS.
> >> later use hot add every other two sockets.
> >>
> >> that will also make BIOS simpler, and it need to support hot-add for
> >> services purpose anyway.
> >>
> > Yes the hot add path was one option we looked at and it did shorten boot
> > times but the goal I had here is to get from power on to having the full
> > machine available as quick as possible. Several clients need significant
> > portions of ram for their key workloads.  So that guided my thoughts on this
> > patch.
> 
> you mean boot small number sockets + hot add still take more time?
> hot add ram still in serialize mode?
> 
> Yinghai

Yes the hot add path is still fairly serial.
lock_memory_hotplug() is still a global lock, which effectivly serializes
online pages.  Since the hotplug lock could done per node but for that to be 
effective something would need to be done with lock_system_sleep() since is
called by lock_memory_hotplug().

Nate
