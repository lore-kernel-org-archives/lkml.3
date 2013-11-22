Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3KVBDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:03:49 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42422 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab3KVBDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:03:45 -0500
Date: Thu, 21 Nov 2013 17:03:11 -0800
From: Kees Cook <keescook@chromium.org>
To: Greg KH <greg@kroah.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131122010311.GZ5274@outflux.net>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131121190350.GC17070@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121190350.GC17070@kroah.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 21, 2013 at 11:03:50AM -0800, Greg KH wrote:
> On Wed, Nov 20, 2013 at 12:50:49PM -0500, Vivek Goyal wrote:
> > This patch implements the in kernel kexec functionality. It implements a
> > new system call kexec_file_load. I think parameter list of this system
> > call will change as I have not done the kernel image signature handling
> > yet. I have been told that I might have to pass the detached signature
> > and size as part of system call.
> 
> This could be done as we do with modules, and just tack the signature
> onto the end of the 'blob' of the image.  That way we could use the same
> tool to sign the binary as we do for modules, and save the need for
> extra parameters in the syscall.

As long as the system call passing in an fd, I'm all good. For those
of us that run from verified filesystems, we don't need the additional
signing overhead, but we do need the file descriptor to validate the
origin of the kernel.

-Kees

-- 
Kees Cook
Chrome OS Security
