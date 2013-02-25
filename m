Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046Ab3BYMjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 07:39:32 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27949 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3BYMjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 07:39:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,735,1355097600"; 
   d="scan'208";a="9357485"
Date: Mon, 25 Feb 2013 12:39:27 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dongsheng Song <dongsheng.song@gmail.com>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
In-Reply-To: <20130224144017.GB1111@kroah.com>
Message-ID: <alpine.DEB.2.02.1302251157210.5360@kaball.uk.xensource.com>
References: <20130223072959.GA4894@www.outflux.net> <CAE8XmWoX_TyHMTnGCMn6j_qiK0hptCgyrnVYpDJkfTAQfUNQPA@mail.gmail.com> <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com> <CAE8XmWq+dA5Pvhyoxm2Nqbt0psLpPxUdR7i5MKFhxVxubY0QtQ@mail.gmail.com>
 <20130224144017.GB1111@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013, Greg Kroah-Hartman wrote:
> On Sun, Feb 24, 2013 at 05:51:44PM +0800, Dongsheng Song wrote:
> > On Sun, Feb 24, 2013 at 1:03 AM, Kees Cook <keescook@chromium.org> wrote:
> > > On Sat, Feb 23, 2013 at 3:59 AM, Dongsheng Song
> > > <dongsheng.song@gmail.com> wrote:
> > >> On Sat, Feb 23, 2013 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
> > >>>
> > >>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> > >>> while now and is almost always enabled by default. As agreed during the
> > >>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> > >>>
> > >>> Signed-off-by: Kees Cook <keescook@chromium.org>
> > >>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > >>> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> > >>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > >>> ---
> > >>>  arch/x86/xen/Kconfig |    2 +-
> > >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> > >>> index 93ff4e1..8cada4c 100644
> > >>> --- a/arch/x86/xen/Kconfig
> > >>> +++ b/arch/x86/xen/Kconfig
> > >>> @@ -53,7 +53,7 @@ config XEN_DEBUG_FS
> > >>>
> > >>>  config XEN_X86_PVH
> > >>>         bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > >>
> > >> Why not remove this 'EXPERIMENTAL' too ?
> > >
> > > It was unclear to me if the feature was actually considered unstable.
> > > I can resend with the text removed from the title too, if that's the
> > > correct action here?
> > >
> > > -Kees
> > >
> > 
> > If such a feature was considered unstable, it should depends on EXPERIMENTAL.
> 
> CONFIG_EXPERIMENTAL is going away.
> 
> > We should not surprised users.
> 
> You should not have unstable options in the kernel in the first place,
> sorry.
 
With the premise that the removal of CONFIG_EXPERIMENTAL is not an issue
for me personally or my work, I am going to give you my 2 cents on the
matter, but feel free to ignore them :)

While I understand that CONFIG_EXPERIMENTAL has been abused, I feel that
rejecting everything that is not fully stable and with external
interfaces set in stones, might hinder the development of new features.

After all, given how fast the kernel is moving nowadays, maintaining a
project out-of-tree until is completely ready for production can be
very expensive. Merging the project earlier and completing the
development upstream can bring better results. But in these cases one
wouldn't want to "market" the feature as stable yet, because it just
isn't. If CONFIG_EXPERIMENTAL is going away, is there anything in the
kernel that can be used to tag a feature as "I wouldn't use it in
production if I were you"? Maybe just a comment in the kconfig
description?
