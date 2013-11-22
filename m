Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3KVTsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:48:19 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51503 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771Ab3KVTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:48:18 -0500
X-Sasl-enc: 873KhqJdbFAE1XUKyAA/WT3j2U9DClREiLHawanL9gzM 1385149695
Date: Fri, 22 Nov 2013 11:48:14 -0800
From: Greg KH <greg@kroah.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, hpa@zytor.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131122194814.GC25105@kroah.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <8761rl73s7.fsf@xmission.com>
 <20131122015518.GA31921@redhat.com>
 <87txf4y304.fsf@xmission.com>
 <20131122141945.GE4046@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122141945.GE4046@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:19:46AM -0500, Vivek Goyal wrote:
> On Fri, Nov 22, 2013 at 05:34:03AM -0800, Eric W. Biederman wrote:
> 
> [..]
> > > Why ELF case is so interesting. I have not use kexec to boot ELF
> > > images in years and have not seen others using it too. In fact bzImage
> > > seems to be the most common kernel image format for x86, most of the distros
> > > ship and use.
> > 
> > ELF is interesting because it is the minimal file format that does
> > everything you need.   So especially for a proof of concept ELF needs to
> > come first.  There is an extra virtual address field in the ELF segment
> > header but otherwise ELF does not have any unnecessary fields.
> > 
> > ELF is interesting because it is the native kernel file format on all
> > architectures linux supports including x86.
> > 
> > ELF is interesting because producing an ELF image in practice requires
> > a trivial amount of tooling so it is a good general purpose format to
> > support.
> 
> Ok. I will have a look at ELF loader too. I was hoping to keep only one
> loader in initial patch. But looks like that's not acceptable.

I totally disagree.  I think what you have done now is fine.  If it
works for bzImage, it's a good sense that this is usable as-is.

And, if someone else cares about signed elf images, hey, let them
implement the loader for it :)

Either way, the syscall interface wouldn't change, which is the
important thing to get right, so you should be fine for now.

thanks,

greg k-h
