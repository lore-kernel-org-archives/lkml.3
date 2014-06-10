Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaFJTjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:39:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaFJTjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:39:40 -0400
Date: Tue, 10 Jun 2014 21:39:27 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3.4 82/88] xen/setup: Populate freed MFNs from non-RAM
 E820 entries and gaps to E820 RAM
Message-ID: <20140610193927.GS15989@olila.local.net-space.pl>
References: <20140610002424.500996570@linuxfoundation.org>
 <20140610002427.192691272@linuxfoundation.org>
 <5396CACF.6050801@citrix.com>
 <20140610093011.GL15989@olila.local.net-space.pl>
 <53970598.6090008@citrix.com>
 <20140610184537.GA15811@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610184537.GA15811@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:45:37AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Jun 10, 2014 at 02:18:16PM +0100, David Vrabel wrote:
> > On 10/06/14 10:30, Daniel Kiper wrote:
> > > On Tue, Jun 10, 2014 at 10:07:27AM +0100, David Vrabel wrote:
> > >> On 10/06/14 01:25, Greg Kroah-Hartman wrote:
> > >>> 3.4-stable review patch.  If anyone has any objections, please let me know.
> > >>
> > >> This is a new feature and not a bug fix.  I don't think it (and patches
> > >> 83-85) are suitable for stable.
> > >
> > > IIRC, this is the main patch fixing dom0 memory looses.
> > > Earlier patches are preparatory stuff and later ones are
> > > fixing bugs introduced by this patch and others. Konrad and I
> > > picked only minimal set of patches to fix that issue in 3.4.
> >
> > This is not a bug fix.  dom0 was previously required to use the balloon
> > driver to recover memory freed during setup.  This was annoying but not
> > a bug.
> >
> > This patches makes significant changes to how much memory dom0 ends up.
> >  Depending on hardware, the dom0_mem option, and the (non)use of the
> > balloon driver  applying this could result is between 1 - 3 GB of
> > additional memory allocated to dom0.  This could result in there being
> > insufficient host memory available to start a VM.
> >
> > Please do not add to 3.4.y.
>
> Ok, fun stuff, I have two maintainers of the same subsystem arguing over
> if the patches should be sent to the stable tree.
>
> So, what do I do, any ideas?  Flip a coin?  Ask the third maintainer
> (Boris) to break the tie?
>
> Konrad and Daniel, are distros using this patchset in 3.4 releases?
> What made you want to create them in the first place?  Who was
> complaining that warranted this work being done?

I use this kernel version in my private production systems. I thought
that it is worth posting such fixes and make them part of stable.
However, as I can see David (who is maintainer) has some concerns,
Konrad (who is maintainer) was also not so strongly convinced to post
them, Boris (who is maintainer) is not involved and I am not maintainer.
So I think that in this situation you should drop them. Sorry for confusion.

Daniel
