Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501Ab3GSNSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:18:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25823 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760485Ab3GSNSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:18:36 -0400
Date: Fri, 19 Jul 2013 15:18:19 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Brandon Philips <brandon@ifup.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: is kexec on Xen domU possible?
Message-ID: <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
References: <20130719020603.GA22932@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719020603.GA22932@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 07:06:03PM -0700, Greg KH wrote:
> Hi all,
>
> I was messing around with kexec and it seems to work just fine on KVM,
> but for Xen domU images, it doesn't work at all.  Daniel, I saw some
> patches from you back in September 2012 for adding this support for
> Dom0, but they don't seem to have gone into the kernel (but other

At first I was going use existing in Xen kexec implementation for Dom0.
However, after some discussion on Xen-devel and LKML we stated that
this implementation is completely broken and should be rewriten. David
Vrabel from Citrix wrote new kexec implementation for Xen which does
not relay on Linux kernel. I hope that it will be included in Xen 4.4 release.

> patches went into kexec-tools at that time.)  You mention that domU

These are mostly fixes which were needed for planned Xen kexec support.
IIRC, they are also needed for systems using ancient Xen Linux Kernel 2.18.
However, most of this implementation will be replaced by new one written
by David Vrabel. It will contain support only for new Xen Dom0 kexec implentation.

> support is "easy" after your patches go in, is that because Dom0 needs
> to support this, or is it something specific to only domU?

In case of domU we should consider following cases:
  - PV guests: there is no support for kexec at this time;
    Once I wrote an implementatation for that type of guests
    for one company but according to our agreement I could not
    publish this code; However, I could use it as a base for
    publicly available kexec implementation; Currently, I do
    not have any plans to work on this due to some more important
    stuff to do; However, question about kexec support for PV
    guests is raised from time to time and maybe this issue
    will be much more important than others once,
  - HVM guests: kexec should work without any issue,
  - PVonHVM guests: IIRC, there were some issues with PV
    drivers but they were fixed some time ago by patches
    posted by Olaf Hering,
  - PVH guests: those type of guests are not available in Xen
    current releases yet; However, Konrad Wilk done some preliminary
    work on kexec support but there are still some issues to resolve.

I do not know what are you trying to do but if you would like
to get some crash dumps there is also another solution to that.
You could use xm/xl dump-core from Dom0 to get dumps of domU memory.

> Also, what's the status of those patches for the kernel, I don't see
> them reposted anywhere, did you drop them?

They were dropped. Please look above for details.

I hope that helps.

Daniel
