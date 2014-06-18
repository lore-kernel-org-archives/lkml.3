Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaFROd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:33:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50808 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaFROdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:33:55 -0400
Date: Wed, 18 Jun 2014 10:31:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Fleming <matt@console-pimps.org>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 0/7] xen: Add EFI support
Message-ID: <20140618143143.GB8545@laptop.dumpdata.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <20140618141541.GM24049@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618141541.GM24049@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 03:15:41PM +0100, Matt Fleming wrote:
> On Fri, 13 Jun, at 07:00:16PM, Daniel Kiper wrote:
> > Hey,
> > 
> > This patch series adds EFI support for Xen dom0 guests.
> > It is based on Jan Beulich and Tang Liang work. I was
> > trying to take into account all previous comments,
> > however, if I missed something sorry for that.
> > 
> > Daniel
> > 
> >  arch/x86/kernel/setup.c          |    4 +-
> >  arch/x86/platform/efi/efi.c      |   77 ++++++++++-------
> >  arch/x86/xen/enlighten.c         |   24 ++++++
> >  drivers/firmware/efi/efi.c       |   26 +++---
> >  drivers/xen/Kconfig              |    4 +
> >  drivers/xen/Makefile             |    3 +
> >  drivers/xen/efi.c                |  374 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/efi.h              |    3 +-
> >  include/xen/interface/platform.h |  123 +++++++++++++++++++++++++++
> >  9 files changed, 595 insertions(+), 43 deletions(-)
> 
> FWIW I'm much happier with this version than v4. There's nothing that
> jumps out at me as being obviously wrong. Just a few minor cleanups
> needed.

Fantastic!
> 
> Which tree is this intended to go through? I'm more than happy to take
> it through the EFI tree, particularly since it touches
> include/linux/efi.h and drivers/firmware/efi/efi.c which is the core EFI
> interface for all platforms.

Your tree is perfect. I presume you do some automatic regression testing
when you have accumulated a tons of patch - so if any of them cause havoc
we can catch them before the merge window and fix them.

> 
> But if it's going through the Xen tree or something, I can supply my
> Acked-by's (once the aforementioned minor cleanups are taken care of).

Nah, lets do your tree. And either Boris, me or David will supply
the Acked-by on the drivers/xen* and arch/x86/xen/* so all the
right tags are in place.

Thanks again!
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
