Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3FTOxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:53:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54711 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757670Ab3FTOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:53:42 -0400
Message-ID: <1371740019.2372.3.camel@dabdike>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Date: Thu, 20 Jun 2013 07:53:39 -0700
In-Reply-To: <20130620094446.GA17882@srcf.ucam.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
	 <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic>
	 <20130619130434.GB24957@gmail.com> <20130619160804.GB27832@srcf.ucam.org>
	 <20130620091321.GB6811@gmail.com> <20130620091537.GA17159@srcf.ucam.org>
	 <20130620092237.GA6943@gmail.com> <20130620093337.GI32694@pd.tnic>
	 <20130620094446.GA17882@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 10:44 +0100, Matthew Garrett wrote:
> On Thu, Jun 20, 2013 at 11:33:37AM +0200, Borislav Petkov wrote:
> > This will break the Macs so maybe we can do
> > 
> > efi=no_11_map
> > 
> > so the Macs can still boot but use the 1:1 map by default.
> 
> I'm going to guess that there are more people running unmodified Linux 
> kernels on Macs than there are people using kexec, so just pass the high 
> maps by default and let the enterprise kernels that care about kexec do 
> something different.

Do we have to make this a popularity contest?  Parallels is currently in
beta with a ksplice like upgrade involving kexec ... basically you
checkpoint the system to ram, kexec to the new kernel and restore the
images from ram ... it can upgrade a new kernel in a matter of seconds
(and unlike ksplice, it's the correct kernel and can move between major
versions).  Since all the components that do this are open source, we
anticipate this will become a common way to maintain servers, so kexec
will see even more use than it currently does.

Can't we detect Macs from some of the UEFI strings at boot time and do
the right thing with the boot switch (which can be overriden from the
kernel command line if we get it wrong)?

James




