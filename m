Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3BYL5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:57:22 -0500
Received: from smtp.citrix.com ([66.165.176.89]:10533 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab3BYL5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:57:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,735,1355097600"; 
   d="scan'208";a="9349814"
Date: Mon, 25 Feb 2013 11:57:17 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dongsheng Song <dongsheng.song@gmail.com>
Subject: Re: [Xen-devel] [PATCH] arch/x86/xen: remove depends on
 CONFIG_EXPERIMENTAL
In-Reply-To: <1361784321.26546.162.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1302251156480.5360@kaball.uk.xensource.com>
References: <20130223072959.GA4894@www.outflux.net>  <CAE8XmWoX_TyHMTnGCMn6j_qiK0hptCgyrnVYpDJkfTAQfUNQPA@mail.gmail.com>  <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com>  <20130223191104.GA12606@konrad-lan.dumpdata.com> 
 <alpine.DEB.2.02.1302232045320.5360@kaball.uk.xensource.com> <1361784321.26546.162.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013, Ian Campbell wrote:
> On Sat, 2013-02-23 at 20:47 +0000, Stefano Stabellini wrote:
> > On Sat, 23 Feb 2013, Konrad Rzeszutek Wilk wrote:
> > > On Sat, Feb 23, 2013 at 09:03:20AM -0800, Kees Cook wrote:
> > > > On Sat, Feb 23, 2013 at 3:59 AM, Dongsheng Song
> > > > <dongsheng.song@gmail.com> wrote:
> > > > > On Sat, Feb 23, 2013 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
> > > > >>
> > > > >> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> > > > >> while now and is almost always enabled by default. As agreed during the
> > > > >> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> > > > >>
> > > > >> Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > >> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > >> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > >> ---
> > > > >>  arch/x86/xen/Kconfig |    2 +-
> > > > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >>
> > > > >> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> > > > >> index 93ff4e1..8cada4c 100644
> > > > >> --- a/arch/x86/xen/Kconfig
> > > > >> +++ b/arch/x86/xen/Kconfig
> > > > >> @@ -53,7 +53,7 @@ config XEN_DEBUG_FS
> > > > >>
> > > > >>  config XEN_X86_PVH
> > > > >>         bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > > > >
> > > > > Why not remove this 'EXPERIMENTAL' too ?
> > > > 
> > > > It was unclear to me if the feature was actually considered unstable.
> > > > I can resend with the text removed from the title too, if that's the
> > > > correct action here?
> > > 
> > > It certainly is unstable right now (which is why it was unstaged from
> > > the v3.9 train). I hope that by v3.10 it won't be - at which
> > > point this patch (and the EXPERIMENTAL) makes sense.
> > > 
> > > So could you respin it please with the text removed as well - and I will
> > > queue it up in the branch that carries the PVH feature?
> > 
> > We also have the same flag on Xen ARM, and the reason is that the ABI is
> > not stable yet. As soon as it is (I think soon now), I'll send a patch
> > to remove EXPERIMENTAL from there too.
> 
> In the meantime if the depends EXPERIMENTAL is going away perhaps we
> should explain the EXPERIMENTAL in the title:
> 
> 8<----------------------------------------------------
> 
> From bc22bd0f7b20296c449a05d82be950922042bc92 Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ian.campbell@citrix.com>
> Date: Thu, 4 Oct 2012 09:12:51 +0100
> Subject: [PATCH] arm: xen: explain the EXPERIMENTAL dependency in the Kconfig help
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/arm/Kconfig |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 67874b8..ef14873 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1865,6 +1865,14 @@ config XEN
>  	help
>  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
>  
> +
> +	  This option is EXPERIMENTAL because the hypervisor
> +	  interfaces which it uses are not yet considered stable
> +	  therefore backwards and forwards compatibility is not yet
> +	  guaranteed.
> +
> +	  If unsure, say N.
> +
>  endmenu
>  
>  menu "Boot options"
> -- 
> 1.7.2.5
> 
> 
> 
> 
