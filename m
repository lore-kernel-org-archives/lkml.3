Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab3D2UbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:31:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63267 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab3D2UbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:31:05 -0400
Date: Mon, 29 Apr 2013 14:45:46 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: For review: user_namespaces(7) man page
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>
In-Reply-To: <CAFLxGvzXkGcR=Wyx8YZKKRACEnNLMA0xQoDfruq7CT1D-FNLnA@mail.gmail.com>
	(from richard.weinberger@gmail.com on Mon Apr 29 02:45:45 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1367264746.18069.186@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 02:45:45 AM, richard -rw- weinberger wrote:
> On Thu, Mar 21, 2013 at 4:52 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
> > Hi Serge,
> >
> > On Fri, Mar 15, 2013 at 4:38 PM, Serge Hallyn  
> <serge.hallyn@ubuntu.com> wrote:
> >> Hi,
> >>
> >> you mention that after creating a new user namespace you at first  
> have
> >> all capabilities in the new ns.  You don't explicitly mention (or I
> >> missed it - I did see the mention of securebits) that if you want  
> to
> >> keep those capabilities after doing an exec, you need to first have
> >> something mapped to uid 0 in the userns, and do setuid(0).
> >
> > Good point. I'll add something on that.
> >
> >> You might not want to list manpages from other projects,
> >
> > Actually, not a problem. Many of the pages in my set already do  
> this.
> >
> >> but Eric's
> >> shadow patches introduce some good new manpages as well.  Those  
> aren't yet
> >> accepted upstream, but if/when they are then mention at least of
> >> subuid(5), subgid(5), and newuidmap(1) and newgidmap(1) might be  
> good.
> >
> > I'll add those.
> >
> > Cheers,
> >
> > Michael
> 
> Can we please also document which capabilities are useless within an
> user namespace?
> E.g. CAP_MKNOD.
> You get this capability but the kernel always checks it against the
> initial userns.

Is there a device namespace?

I vaguely recall OpenVZ implemented moving individual PCI devices into  
containers so some large movie company could put one video card in each  
container for render farms. There are lots of devices that aren't  
_really_ privileged (/dev/zero, /dev/null, /dev/full, /dev/ram) and  
more that could be emulated...

(Really this seems like a situation where devtmpfs needs -o newinstance  
and a corresponding filtered event netlink feed to pass to udev/mdev.  
And that might even have been feasible before Greg decided that  
devtmpfs needed to have opinions about uids. Oh well.)

Rob