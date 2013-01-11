Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3AKQzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:55:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41686 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3AKQzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:55:37 -0500
Date: Fri, 11 Jan 2013 11:55:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
Message-ID: <20130111165506.GD25620@phenom.dumpdata.com>
References: <50DC58C4.3000307@citrix.com>
 <874nj7qsor.fsf@xmission.com>
 <50E41973.9050705@citrix.com>
 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
 <50E6F81D02000078000B3245@nat28.tlf.novell.com>
 <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
 <20130104191146.GC6721@phenom.dumpdata.com>
 <20130107123404.GA2927@host-192-168-1-59.local.net-space.pl>
 <20130107162018.GJ3219@phenom.dumpdata.com>
 <87ehhsqrpr.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehhsqrpr.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 08:16:48PM -0800, Eric W. Biederman wrote:
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
> 
> > On Mon, Jan 07, 2013 at 01:34:04PM +0100, Daniel Kiper wrote:
> >> I think that new kexec hypercall function should mimics kexec syscall.
> >> It means that all arguments passed to hypercall should have same types
> >> if it is possible or if it is not possible then conversion should be done
> >> in very easy way. Additionally, I think that one call of new hypercall
> >> load function should load all needed thinks in right place and
> >> return relevant status. Last but not least, new functionality should
> >
> > We are not restricted to just _one_ hypercall. And this loading
> > thing could be similar to the micrcode hypercall - which just points
> > to a virtual address along with the length - and says 'load me'.
> >
> >> be available through /dev/xen/privcmd or directly from kernel without
> >> bigger effort.
> >
> > Perhaps we should have a email thread on xen-devel where we hash out
> > some ideas. Eric, would you be OK included on this - it would make
> > sense for this mechanism to be as future-proof as possible - and I am not
> > sure what your plans for kexec are in the future?
> 
> The basic kexec interface is.
> 
> load ranges of virtual addresses physical addresses.
> jump to the physical address  with identity mapped page tables.
> 
> There are a few flags to allow for different usage scenarios like
> kexec on panic vs normal kexec.

And there is nothing fancy to be done for EFI and SecureBoot? Or is
that something that the kernel has to handle on its own (so somehow
passing some certificates to somewhere).

> 
> It is very very simple and very extensible.  All of the weird glue
> happens in userspace.
> 
> Eric
