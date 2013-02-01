Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422787Ab3BANTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:19:50 -0500
Received: from smtp.citrix.com ([66.165.176.89]:65152 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422729Ab3BANTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:19:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,579,1355097600"; 
   d="scan'208";a="5948641"
Date: Fri, 1 Feb 2013 13:19:37 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Beulich <JBeulich@suse.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
In-Reply-To: <510AE4F6.1050407@zytor.com>
Message-ID: <alpine.DEB.2.02.1302011307440.10432@kaball.uk.xensource.com>
References: <1359507077-26050-1-git-send-email-kys@microsoft.com> <1359507108-26091-1-git-send-email-kys@microsoft.com> <1359507108-26091-2-git-send-email-kys@microsoft.com> <5108ED9702000078000BAA08@nat28.tlf.novell.com> <510AE4F6.1050407@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, H. Peter Anvin wrote:
> On 01/30/2013 12:53 AM, Jan Beulich wrote:
> > 
> > I'm not convinced that's the right approach - any hypervisor
> > could do similar emulation, and hence you either want to make
> > sure you run on Hyper-V (by excluding all others), or you
> > tolerate using the emulation (which may require syncing up with
> > the other guest implementations so that shared resources don't
> > get used by two parties).
> > 
> > I also wonder whether using the Hyper-V emulation (where
> > useful, there might not be anything right now, but this may
> > change going forward) when no Xen support is configured
> > wouldn't be better than not using anything...
> > 
> 
> I'm confused about "the right approach" here is.  As far as I
> understand, this only can affect a Xen guest where HyperV guest support
> is enabled but not Xen support, and only because Xen emulates HyperV but
> does so incorrectly.
> 
> This is a Xen bug, and as such it makes sense to reject Xen
> specifically.  If another hypervisor emulates HyperV and does so
> correctly there seems to be no reason to reject it.

I don't think so.

AFAIK originally there were features exported as flags and Xen doesn't
turn on the flags that correspond to features that are not implemented.
The problem here is that Hyper-V is about to introduce a feature without
a flag that is not implemented by Xen (see "X86: Deliver Hyper-V
interrupts on a separate IDT vector").
K.Y. please confirm if I got this right.

If I were the Microsoft engineer implementing this feature, no matter
what Xen does or does not, I would also make sure that there is a
corresponding flag for it, because in my experience they avoid future
headaches.
I wonder what happens if you run Linux with Hyper-V support on an old
Hyper-V host that doesn't support vector injection.
