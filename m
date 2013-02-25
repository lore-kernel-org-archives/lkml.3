Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3BYOgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:36:43 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33620 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3BYOgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:36:42 -0500
Date: Mon, 25 Feb 2013 06:37:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Dongsheng Song <dongsheng.song@gmail.com>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130225143730.GC14007@kroah.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 12:39:27PM +0000, Stefano Stabellini wrote:
> On Sun, 24 Feb 2013, Greg Kroah-Hartman wrote:
> > 
> > You should not have unstable options in the kernel in the first place,
> > sorry.
>  
> With the premise that the removal of CONFIG_EXPERIMENTAL is not an issue
> for me personally or my work, I am going to give you my 2 cents on the
> matter, but feel free to ignore them :)
> 
> While I understand that CONFIG_EXPERIMENTAL has been abused, I feel that
> rejecting everything that is not fully stable and with external
> interfaces set in stones, might hinder the development of new features.

It's been this way for _years_ this isn't something new (the "you have
to get it right really quickly" problem).  See Documentation/ABI/ for
some words about how you can try to do this.

> After all, given how fast the kernel is moving nowadays,

No faster than it has in the past.

> maintaining a project out-of-tree until is completely ready for
> production can be very expensive. Merging the project earlier and
> completing the development upstream can bring better results.

Yes, but don't go changing user-visable apis when you do so.  That's
been a hard rule for a LONG time.

> But in these cases one wouldn't want to "market" the feature as stable
> yet, because it just isn't. If CONFIG_EXPERIMENTAL is going away, is
> there anything in the kernel that can be used to tag a feature as "I
> wouldn't use it in production if I were you"? Maybe just a comment in
> the kconfig description?

I know this is hard, I've had my own problems with it in the past.  You
don't know if you get an api right until you have a lot of users.  See
our previous "discussions" about this topic on lkml if you are curious
as to the eventual outcome of threads like this:

	Yes, it's hard, but that's kernel programming.

Sorry,

greg k-h
