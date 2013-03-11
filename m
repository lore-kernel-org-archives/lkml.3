Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3CKVGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:06:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3CKVGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:06:33 -0400
Date: Mon, 11 Mar 2013 17:06:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311210628.GG14738@redhat.com>
References: <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
 <20130311192021.GF12107@redhat.com>
 <513E36CB.5040908@zytor.com>
 <20130311201245.GC14738@redhat.com>
 <513E3C44.9030402@zytor.com>
 <87hakhk6xu.fsf@xmission.com>
 <20130311204530.GE14738@redhat.com>
 <CAE9FiQUPVP59Ngo2TGABD-vwVRA7rhgE+MgBCT1b=U_EQgsUdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUPVP59Ngo2TGABD-vwVRA7rhgE+MgBCT1b=U_EQgsUdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:57:41PM -0700, Yinghai Lu wrote:
> On Mon, Mar 11, 2013 at 1:45 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > In my experience, trying to keep foot-print small has kind of been a
> > losing battle.
> >
> > - People want more functionality in second kernel, want to dump to more
> >   complicated IO stacks and that requires pulling in more drivers,
> >   more libraries, more daemons, more user space tools and what not.
> >
> > - Now we use dracut generated initramfs and it has been growing in size.
> >   Now systemd has been pulled in too.
> >
> > - Drivers keep on increasing their memory usage.
> 
> If the dump file will be only put one place, why should all the drivers
> for all devices get loaded?
> for example: dump will be on disk with one scsi controller, can you only
> load driver that contoller? and forget about all other storage controller and
> network etc drivers.

We do try to optimize things this way. Only include drivers as needed. But
a single driver might be handling lots of cards and then try to bring
up all the cards in second kernel.

Just fixed some issues with one driver where around 40MB extra memory
was benig consumed because of multiqueue support. Just bunch of allocation
in driver. And we used kernel command line to disable it.

Point being, in practice how many software development areas one can
change to keep memory requirement with-in few MBs. I have been doing
it for last few years and it has been very hard.

Thanks
Vivek
