Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3KUTVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:21:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3KUTVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:21:46 -0500
Date: Thu, 21 Nov 2013 14:21:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 5/6] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20131121192114.GN16208@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-6-git-send-email-vgoyal@redhat.com>
 <20131121190710.GD17070@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121190710.GD17070@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:07:10AM -0800, Greg KH wrote:
> On Wed, Nov 20, 2013 at 12:50:50PM -0500, Vivek Goyal wrote:
> > This is loader specific code which can load bzImage and set it up for
> > 64bit entry. This does not take care of 32bit entry or real mode entry
> > yet.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  arch/x86/include/asm/kexec-bzimage.h |   12 +
> >  arch/x86/include/asm/kexec.h         |   26 +++
> >  arch/x86/kernel/Makefile             |    2 +
> >  arch/x86/kernel/kexec-bzimage.c      |  375 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/machine_kexec_64.c   |    4 +-
> >  arch/x86/kernel/purgatory_entry_64.S |  119 +++++++++++
> >  6 files changed, 537 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/x86/include/asm/kexec-bzimage.h
> >  create mode 100644 arch/x86/kernel/kexec-bzimage.c
> >  create mode 100644 arch/x86/kernel/purgatory_entry_64.S
> 
> Wow, that's surprisingly small, nice job.
> 
> What do you mean by the "real mode entry"?  Do we need to care about
> that because we aren't falling back to real mode when executing this,
> are we?  Or does that just happen for 32bit kernels?

Original kexec offers real mode entry choice too. So we fall back
to real mode and jump to kernel and kernel makes bunch of BIOS calls. I
don't think this is a commonly used option.

For 32bit kernels, currently by default we use 32bit entry point of
bzImage and we don't drop to real mode. Real mode entry is forced
by user using command line option --real-mode to kexec-tools.

So this is one of the features of existing kexec-tools I just wanted
to make it explicitly clear that I have not taken care of that feature
as it is not a commonly used one. If somebody needs it, they can implement
it.

Thanks
Vivek
