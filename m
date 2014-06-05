Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaFEJ4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaFEJ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:56:50 -0400
Date: Thu, 5 Jun 2014 17:56:03 +0800
From: WANG Chao <chaowang@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, jkosina@suse.cz, dyoung@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 06/13] kexec: New syscall kexec_file_load() declaration
Message-ID: <20140605095603.GD3876@dhcp-17-89.nay.redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-7-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401800822-27425-7-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 at 09:06am, Vivek Goyal wrote:
> This is the new syscall kexec_file_load() declaration/interface. I have
> reserved the syscall number only for x86_64 so far. Other architectures
> (including i386) can reserve syscall number when they enable the support
> for this new syscall.

Hi, Vivek

I have a comment below about the kexec_file_load args.

[..]
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index c435c5f..a3044e6 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1098,6 +1098,13 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
>  }
>  #endif
>  
> +SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
> +		const char __user *, cmdline_ptr, unsigned long,
> +		cmdline_len, unsigned long, flags)

initrd is optional for system boot.

How about using int *kernel_fd and int *initrd_fd as the argument? Then
if I don't need initrd, in userspace I can do this:

kexec_file_load(&kernel_fd, NULL, ...)

And even you can remove KEXEC_FILE_UNLOAD flag, because you could tell
that one wants to unload if the following is invoked:

kexec_file_load(NULL, NULL, ...)

Thanks
WANG Chao
