Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3BWTL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 14:11:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20540 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3BWTLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 14:11:55 -0500
Date: Sat, 23 Feb 2013 14:11:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Kees Cook <keescook@chromium.org>
Cc: Dongsheng Song <dongsheng.song@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130223191104.GA12606@konrad-lan.dumpdata.com>
References: <20130223072959.GA4894@www.outflux.net>
 <CAE8XmWoX_TyHMTnGCMn6j_qiK0hptCgyrnVYpDJkfTAQfUNQPA@mail.gmail.com>
 <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 09:03:20AM -0800, Kees Cook wrote:
> On Sat, Feb 23, 2013 at 3:59 AM, Dongsheng Song
> <dongsheng.song@gmail.com> wrote:
> > On Sat, Feb 23, 2013 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
> >>
> >> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> >> while now and is almost always enabled by default. As agreed during the
> >> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> ---
> >>  arch/x86/xen/Kconfig |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> >> index 93ff4e1..8cada4c 100644
> >> --- a/arch/x86/xen/Kconfig
> >> +++ b/arch/x86/xen/Kconfig
> >> @@ -53,7 +53,7 @@ config XEN_DEBUG_FS
> >>
> >>  config XEN_X86_PVH
> >>         bool "Support for running as a PVH guest (EXPERIMENTAL)"
> >
> > Why not remove this 'EXPERIMENTAL' too ?
> 
> It was unclear to me if the feature was actually considered unstable.
> I can resend with the text removed from the title too, if that's the
> correct action here?

It certainly is unstable right now (which is why it was unstaged from
the v3.9 train). I hope that by v3.10 it won't be - at which
point this patch (and the EXPERIMENTAL) makes sense.

So could you respin it please with the text removed as well - and I will
queue it up in the branch that carries the PVH feature?

Thanks!
> 
> -Kees
> 
> >
> >> -       depends on X86_64 && XEN && EXPERIMENTAL
> >> +       depends on X86_64 && XEN
> >>         default n
> >>         help
> >>            This option enables support for running as a PVH guest (PV guest
> >> --
> >> 1.7.9.5
> >>
> >>
> >> --
> >> Kees Cook
> >> Chrome OS Security
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
