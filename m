Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab3CANp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:45:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CANp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:45:56 -0500
Date: Fri, 1 Mar 2013 08:45:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v2] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130301134528.GA3690@phenom.dumpdata.com>
References: <20130228215640.GA3136@www.outflux.net>
 <alpine.DEB.2.02.1302282251200.5210@kaball.uk.xensource.com>
 <CAGXu5jKHR+bnx7jc0vC15sJL1rradGt0g230MVOaDLj5NqCBhQ@mail.gmail.com>
 <alpine.DEB.2.02.1302282309510.5210@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1302282309510.5210@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:10:55PM +0000, Stefano Stabellini wrote:
> On Thu, 28 Feb 2013, Kees Cook wrote:
> > On Thu, Feb 28, 2013 at 2:53 PM, Stefano Stabellini
> > <stefano.stabellini@eu.citrix.com> wrote:
> > > On Thu, 28 Feb 2013, Kees Cook wrote:
> > >> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> > >> while now and is almost always enabled by default. As agreed during the
> > >> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> > >>
> > >> Signed-off-by: Kees Cook <keescook@chromium.org>
> > >> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > >> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> > >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > >> ---
> > >>
> > >> v2:
> > >>  - drop EXPERIMENTAL from bool and help text too.
> > >>
> > >> ---
> > >>  arch/x86/xen/Kconfig |    8 +++-----
> > >>  1 file changed, 3 insertions(+), 5 deletions(-)
> > >>
> > >> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> > >> index 93ff4e1..6c5802f 100644
> > >> --- a/arch/x86/xen/Kconfig
> > >> +++ b/arch/x86/xen/Kconfig
> > >> @@ -52,12 +52,10 @@ config XEN_DEBUG_FS
> > >>         Enabling this option may incur a significant performance overhead.
> > >>
> > >>  config XEN_X86_PVH
> > >> -     bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > >> -     depends on X86_64 && XEN && EXPERIMENTAL
> > >> +     bool "Support for running as a PVH guest"
> > >> +     depends on X86_64 && XEN
> > >>       default n
> > >>       help
> > >>          This option enables support for running as a PVH guest (PV guest
> > >>          using hardware extensions) under a suitably capable hypervisor.
> > >> -        This option is EXPERIMENTAL because the hypervisor interfaces
> > >> -        which it uses is not yet considered stable therefore backwards and
> > >> -        forwards compatibility is not yet guaranteed.  If unsure, say N.
> > >> +        If unsure, say N.
> > >
> > > Please do not change the text this way.
> > > The fact that CONFIG_EXPERIMENTAL is going away it doesn't change the
> > > fact that this feature is experimental.
> > > Maybe you want to replace EXPERIMENTAL with experimental, or if
> > > experimental has become as taboo word, I am sure you can find a suitable
> > > synonym.
> > 
> > Ah, sorry, I misunderstood what was being recommended from the other
> > thread (quoting below...)
> > 
> > On Sat, 23 Feb 2013, Konrad Rzeszutek Wilk wrote:
> > > It certainly is unstable right now (which is why it was unstaged from
> > > the v3.9 train). I hope that by v3.10 it won't be - at which
> > > point this patch (and the EXPERIMENTAL) makes sense.
> > 
> > Only "depends on EXPERIMENTAL" must go away. Did you want either the
> > bool or help text to go away too? If neither, my original patch should
> > work. If you only want the bool text gone, I can send that version
> > instead.
> 
> I think your original patch is good, but I'll let Konrad decide.

By the time PVH is going to Linus it better be stable. So the revised
patch is OK with me (fyi, this patch is going in my stable/pvh.v7 which
is part of #linux-next).
