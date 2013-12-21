Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3LUMPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 07:15:39 -0500
Received: from verein.lst.de ([213.95.11.211]:60066 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3LUMPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 07:15:38 -0500
Date: Sat, 21 Dec 2013 13:15:34 +0100
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, Peter Jones <pjones@redhat.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
	kernel kexec
Message-ID: <20131221121534.GB9002@lst.de>
References: <87vbzju6ql.fsf@xmission.com> <20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com> <20131126142759.GA5473@redhat.com> <20131219125439.GA6379@lst.de> <20131220141917.GB27063@redhat.com> <87a9fvqfs4.fsf@xmission.com> <52B4D0C6.2000505@zytor.com> <87ioujf0ox.fsf@xmission.com> <52B50BBB.9070806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B50BBB.9070806@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 07:32:11PM -0800, H. Peter Anvin wrote:
> thing, as currently built there are megabytes of zeroes in it for no
> good reason.

Then remove them ;) AFAICS, that's x86 only? What a waste!

What's the reason? ALIGN_RODATA? Even if so, vmlinux.gz might be
a fair trade-off.

> 
> Even if you don't need the entry code, the additional metadata is
> meaningful.

Any idea, or maybe even a list of features that would get lost?
What are the blossoms of this organically grown structure?
Many architectures, even embedded x86, boot happily any ELF kernel.

I'm with Eric here: this is not about _not_ supporting bzImage, it's
about _do_ support ELF first. As I wrote: if the existing signature 
is, let's say, impractical, and a new one is needed anyway, why not 
(detached-) sign vmlinux or vmlinux.gz?

Every architecture can benefit from a secure boot or secure kexec
that is done right.

	Torsten

