Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaFEPRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbaFEPR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:17:29 -0400
Date: Thu, 5 Jun 2014 11:16:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, jkosina@suse.cz, dyoung@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 06/13] kexec: New syscall kexec_file_load() declaration
Message-ID: <20140605151639.GB14083@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-7-git-send-email-vgoyal@redhat.com>
 <20140605095603.GD3876@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605095603.GD3876@dhcp-17-89.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 05:56:03PM +0800, WANG Chao wrote:

[..]
> > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > index c435c5f..a3044e6 100644
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -1098,6 +1098,13 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
> >  }
> >  #endif
> >  
> > +SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
> > +		const char __user *, cmdline_ptr, unsigned long,
> > +		cmdline_len, unsigned long, flags)
> 
> initrd is optional for system boot.
> 
> How about using int *kernel_fd and int *initrd_fd as the argument? Then
> if I don't need initrd, in userspace I can do this:

Hi Chao,

I really am not too keen converting plain int fd arguments into pointers.

Given the fact that fd is int, that means all valid values are greater
than 0. How about using -1 to denote that initrd is not being loaded?

This does create one little anomaly and that is for all -ve values we
will return -EBADF except -1 which we special cased.

> 
> kexec_file_load(&kernel_fd, NULL, ...)
> 
> And even you can remove KEXEC_FILE_UNLOAD flag, because you could tell
> that one wants to unload if the following is invoked:
> 
> kexec_file_load(NULL, NULL, ...)

I would prefer not to derive special meanings of NULL parameters and
instead use an explicit flag to unload kernel.

Thanks
Vivek
