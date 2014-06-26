Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaFZPOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:14:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44110 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755366AbaFZPOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:14:32 -0400
Date: Thu, 26 Jun 2014 16:14:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Fredrik Noring <fredrik.noring@autoliv.com>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140626151424.GT32514@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int> <20140626140115.GQ32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 02:44:52PM +0000, Mattis Lorentzon wrote:
> Thank you for your reply,
> 
> > On Wed, Jun 25, 2014 at 01:55:05PM +0000, Mattis Lorentzon wrote:
> > > I have a similar issue with v3.16-rc2 as previously reported by Waldemar
> > Brodkorb for v3.15-rc4.
> > > https://lkml.org/lkml/2014/5/9/330
> >
> > This URL returns no useful information.  I find that lkml.org is broken more
> > times than not in recent years.  Please use a different archive site when
> > referring to posts, thanks.
> 
> http://lkml.iu.edu/hypermail/linux/kernel/1405.1/01114.html

I remember that report, but it was never resolved as I think no one has
any ideas what is causing these, and no one has any idea where to start
looking.

> We have managed to trigger the Oops by just transferring a large file
> over nfs
> cat /mnt/foo > /dev/null
> where foo is a file that is approximately 2 GB. There may be some
> packet losses on this network, perhaps this differs from your workload?

That's a similar workload to the one which is mentioned in the previous
report.  I've just set a similar transfer going, but this will be a 16GB
file.

> We have done some more investigations, please find it in this mail:
> 
> http://lkml.iu.edu/hypermail/linux/kernel/1406.3/02190.html

Yes, I saw that before I replied, and my reply was written with that
message in mind.  That's what prompted this paragraph in my previous
reply:

"Your other oops dumps also show various other functions apparantly
returning 0xffffffff.  I can't believe that there's more than one bug
doing this, so I doubt the problem is in these functions.  Something
else must be going on."

One of the problems is that there's soo much work going on with the
kernel by many different parties, pulling it in various directions,
that no one really has an overview of all the changes, and so no one
has much of a feel what could be the cause of weird bugs like this.

I don't know what to suggest - you could try using git bisect to see
if you can track it down to a particular commit, but it sounds like
that's going to be very time consuming.  You mentioned that 3.12
doesn't show the bug, but 3.13 does - so start off telling git bisect
that 3.12 is "good" and 3.13 is "bad".

Hopefully there won't be too many breakages during the 3.13 merge
window (between 3.12 and 3.13-rc1), but I don't have much faith in
that; people seem to have a habbit of holding back fixes until -rc1,
which makes _exactly_ this kind of bug much harder for people like
yourselves to track down - or maybe even impossible.

I'm afraid I can't offer very much help beyond this until either I can
produce it, or someone manages to identify a particular change which
caused this.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
