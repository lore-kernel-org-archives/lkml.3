Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629Ab3BYMzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 07:55:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24076 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3BYMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 07:55:38 -0500
Date: Mon, 25 Feb 2013 07:55:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dongsheng Song <dongsheng.song@gmail.com>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130225125512.GA3135@phenom.dumpdata.com>
References: <20130223072959.GA4894@www.outflux.net>
 <CAE8XmWoX_TyHMTnGCMn6j_qiK0hptCgyrnVYpDJkfTAQfUNQPA@mail.gmail.com>
 <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com>
 <CAE8XmWq+dA5Pvhyoxm2Nqbt0psLpPxUdR7i5MKFhxVxubY0QtQ@mail.gmail.com>
 <20130224144017.GB1111@kroah.com>
 <alpine.DEB.2.02.1302251157210.5360@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1302251157210.5360@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 12:39:27PM +0000, Stefano Stabellini wrote:
> On Sun, 24 Feb 2013, Greg Kroah-Hartman wrote:
> > On Sun, Feb 24, 2013 at 05:51:44PM +0800, Dongsheng Song wrote:
> > > On Sun, Feb 24, 2013 at 1:03 AM, Kees Cook <keescook@chromium.org> wrote:
> > > > On Sat, Feb 23, 2013 at 3:59 AM, Dongsheng Song
> > > > <dongsheng.song@gmail.com> wrote:
> > > >> On Sat, Feb 23, 2013 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
> > > >>>
> > > >>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> > > >>> while now and is almost always enabled by default. As agreed during the
> > > >>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> > > >>>
> > > >>> Signed-off-by: Kees Cook <keescook@chromium.org>
> > > >>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > >>> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > >>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > >>> ---
> > > >>>  arch/x86/xen/Kconfig |    2 +-
> > > >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >>>
> > > >>> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> > > >>> index 93ff4e1..8cada4c 100644
> > > >>> --- a/arch/x86/xen/Kconfig
> > > >>> +++ b/arch/x86/xen/Kconfig
> > > >>> @@ -53,7 +53,7 @@ config XEN_DEBUG_FS
> > > >>>
> > > >>>  config XEN_X86_PVH
> > > >>>         bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > > >>
> > > >> Why not remove this 'EXPERIMENTAL' too ?
> > > >
> > > > It was unclear to me if the feature was actually considered unstable.
> > > > I can resend with the text removed from the title too, if that's the
> > > > correct action here?
> > > >
> > > > -Kees
> > > >
> > > 
> > > If such a feature was considered unstable, it should depends on EXPERIMENTAL.
> > 
> > CONFIG_EXPERIMENTAL is going away.
> > 
> > > We should not surprised users.
> > 
> > You should not have unstable options in the kernel in the first place,
> > sorry.

Just to clarify - this 'unstable' part is that the hypercall interface has
not been nailed down. As such the patchseries ('PVH') is not going in
Linus's tree until that is nailed down. However, the 'PVH' is going in
in 3.10 merge window (barring again delays).

Initially it was scheduled to be in v3.8, hence the reason it has
been lingering in #linux-next.

>  
> With the premise that the removal of CONFIG_EXPERIMENTAL is not an issue
> for me personally or my work, I am going to give you my 2 cents on the
> matter, but feel free to ignore them :)
> 
> While I understand that CONFIG_EXPERIMENTAL has been abused, I feel that
> rejecting everything that is not fully stable and with external
> interfaces set in stones, might hinder the development of new features.
> 
> After all, given how fast the kernel is moving nowadays, maintaining a
> project out-of-tree until is completely ready for production can be
> very expensive. Merging the project earlier and completing the
> development upstream can bring better results. But in these cases one
> wouldn't want to "market" the feature as stable yet, because it just
> isn't. If CONFIG_EXPERIMENTAL is going away, is there anything in the
> kernel that can be used to tag a feature as "I wouldn't use it in
> production if I were you"? Maybe just a comment in the kconfig
> description?
