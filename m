Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaFRPKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:10:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37053 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaFRPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:10:33 -0400
Date: Wed, 18 Jun 2014 17:08:15 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, Matt Fleming <matt@console-pimps.org>,
        andrew.cooper3@citrix.com, david.vrabel@citrix.com,
        ian.campbell@citrix.com, jeremy@goop.org, matt.fleming@intel.com,
        x86@kernel.org, tglx@linutronix.de, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, eshelton@pobox.com,
        mingo@redhat.com, mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Message-ID: <20140618150815.GB28489@olila.local.net-space.pl>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
 <20140618135229.GH24049@console-pimps.org>
 <53A1B726020000780001B6CF@mail.emea.novell.com>
 <alpine.DEB.2.02.1406181523340.13771@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406181523340.13771@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 03:30:25PM +0100, Stefano Stabellini wrote:
> On Wed, 18 Jun 2014, Jan Beulich wrote:
> > >>> On 18.06.14 at 15:52, <matt@console-pimps.org> wrote:
> > > EFI_PARAVIRT will be usable by architectures other than x86, correct? If
> > > your intention is for it only ever to be used by x86, then it should
> > > probably be EFI_ARCH_2.
> >
> > I would expect ARM, once it gets UEFI support on the Xen side, to
> > be able to handle most of this identically to x86. Which raises the
> > question whether most of the new Xen-specific code (in one of the
> > other patches) wouldn't better live under drivers/xen/.
>
> I was thinking the same thing.
>
> However this patch series doesn't add much code outside
> drivers/xen/efi.c and include/xen/interface/platform.h.
> I think it wouldn't be fair to ask Daniel to refactor the efi code
> currently under arch/x86 to an arch-independent location.
> Whoever comes in later and adds EFI Xen support for ARM can do that.

I was doing those EFI patches with ARM support in mind from the beginning.
That is why I moved everything, which was possible, to arch independent
place. There are only some simple init calls from arch/x86. Just a few
required lines. So I think that it will be quite easy to use this EFI
code on ARM platform.

Daniel
