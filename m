Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3J2XF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:05:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3J2XFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:05:25 -0400
Date: Tue, 29 Oct 2013 16:05:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: return correct error code on unimplemented mmap()
Message-ID: <20131029230524.GA14393@kroah.com>
References: <1382977710-1966-1-git-send-email-vladimir_zapolskiy@mentor.com>
 <20131028163549.GC4797@kroah.com>
 <526E9D67.9090504@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526E9D67.9090504@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 07:22:47PM +0200, Vladimir Zapolskiy wrote:
> On 10/28/13 18:35, Greg Kroah-Hartman wrote:
> >On Mon, Oct 28, 2013 at 06:28:30PM +0200, Vladimir Zapolskiy wrote:
> >>Both POSIX.1-2008 and Linux Programmer's Manual have a dedicated return
> >>error code for a case, when a file doesn't support mmap(), it's ENODEV.
> >>
> >>This change replaces overloaded EINVAL with ENODEV in a situation
> >>described above for sysfs binary files.
> >>
> >>Signed-off-by: Vladimir Zapolskiy<vladimir_zapolskiy@mentor.com>
> >>Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> >
> >Is this a problem in linux-next or 3.12-rc7 and older kernels?  What
> >userspace tool is breaking here?
> 
> The patch itself is against 3.12-rc7, but the same problem can be found
> in older kernels as well.
> 
> I assume the bugfix is quite safe, because both EINVAL and ENODEV should
> be handled by user space tools, however for developers it might be
> beneficial to distinguish cases of completely not supported mmap() and
> supported but misused mmap() applied to a binary sysfs file. At the
> moment from the user space perspective there is no indication of
> unsupported mmap() over a file in sysfs.

Ok, fair enough, but it doesn't apply to my tree given the recent sysfs
changes there.  Can you redo this against linux-next, or wait for
3.13-rc1 and resend it against that release in a few weeks?

thanks,

greg k-h
