Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3KVCNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:13:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab3KVCNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:13:44 -0500
Date: Thu, 21 Nov 2013 21:13:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131122021312.GD31921@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131121190350.GC17070@kroah.com>
 <20131122010311.GZ5274@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122010311.GZ5274@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:03:11PM -0800, Kees Cook wrote:
> Hi,
> 
> On Thu, Nov 21, 2013 at 11:03:50AM -0800, Greg KH wrote:
> > On Wed, Nov 20, 2013 at 12:50:49PM -0500, Vivek Goyal wrote:
> > > This patch implements the in kernel kexec functionality. It implements a
> > > new system call kexec_file_load. I think parameter list of this system
> > > call will change as I have not done the kernel image signature handling
> > > yet. I have been told that I might have to pass the detached signature
> > > and size as part of system call.
> > 
> > This could be done as we do with modules, and just tack the signature
> > onto the end of the 'blob' of the image.  That way we could use the same
> > tool to sign the binary as we do for modules, and save the need for
> > extra parameters in the syscall.
> 
> As long as the system call passing in an fd, I'm all good. For those
> of us that run from verified filesystems, we don't need the additional
> signing overhead, but we do need the file descriptor to validate the
> origin of the kernel.

Yep, Greg had mentioned that keep the interface file descriptor based so
that it can work well with LSM hooks and that's why I went with it.

Thanks
Vivek
