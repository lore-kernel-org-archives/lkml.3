Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab3BWUra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 15:47:30 -0500
Received: from smtp.citrix.com ([66.165.176.89]:58310 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab3BWUr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 15:47:29 -0500
X-IronPort-AV: E=Sophos;i="4.84,724,1355097600"; 
   d="scan'208";a="9213307"
Date: Sat, 23 Feb 2013 20:47:27 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Kees Cook <keescook@chromium.org>,
        Dongsheng Song <dongsheng.song@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
In-Reply-To: <20130223191104.GA12606@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1302232045320.5360@kaball.uk.xensource.com>
References: <20130223072959.GA4894@www.outflux.net> <CAE8XmWoX_TyHMTnGCMn6j_qiK0hptCgyrnVYpDJkfTAQfUNQPA@mail.gmail.com> <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com> <20130223191104.GA12606@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2013, Konrad Rzeszutek Wilk wrote:
> On Sat, Feb 23, 2013 at 09:03:20AM -0800, Kees Cook wrote:
> > On Sat, Feb 23, 2013 at 3:59 AM, Dongsheng Song
> > <dongsheng.song@gmail.com> wrote:
> > > On Sat, Feb 23, 2013 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
> > >>
> > >> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> > >> while now and is almost always enabled by default. As agreed during the
> > >> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> > >>
> > >> Signed-off-by: Kees Cook <keescook@chromium.org>
> > >> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > >> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> > >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > >> ---
> > >>  arch/x86/xen/Kconfig |    2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> > >> index 93ff4e1..8cada4c 100644
> > >> --- a/arch/x86/xen/Kconfig
> > >> +++ b/arch/x86/xen/Kconfig
> > >> @@ -53,7 +53,7 @@ config XEN_DEBUG_FS
> > >>
> > >>  config XEN_X86_PVH
> > >>         bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > >
> > > Why not remove this 'EXPERIMENTAL' too ?
> > 
> > It was unclear to me if the feature was actually considered unstable.
> > I can resend with the text removed from the title too, if that's the
> > correct action here?
> 
> It certainly is unstable right now (which is why it was unstaged from
> the v3.9 train). I hope that by v3.10 it won't be - at which
> point this patch (and the EXPERIMENTAL) makes sense.
> 
> So could you respin it please with the text removed as well - and I will
> queue it up in the branch that carries the PVH feature?

We also have the same flag on Xen ARM, and the reason is that the ABI is
not stable yet. As soon as it is (I think soon now), I'll send a patch
to remove EXPERIMENTAL from there too.
