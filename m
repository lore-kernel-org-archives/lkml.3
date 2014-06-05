Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaFEPDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:03:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaFEPDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:03:13 -0400
Date: Thu, 5 Jun 2014 11:01:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, jkosina@suse.cz, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140605150159.GA14083@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140603131203.GA23395@redhat.com>
 <20140605083134.GE3506@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605083134.GE3506@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 04:31:34PM +0800, Dave Young wrote:

[..]
> > +	ret = kexec_file_load(kernel_fd, info.initrd_fd, info.command_line,
> > +			info.command_line_len, info.kexec_flags);
> 
> Vivek,
> 
> I tried your patch on my uefi test machine, but kexec load fails like below:
> 
> [root@localhost ~]# kexec -l /boot/vmlinuz-3.15.0-rc8+ --use-kexec2-syscall
> Could not find a free area of memory of 0xa000 bytes ...

Hi Dave,

I think this message is coming from kexec-tools from old loading path. I
think somehow new path did not even kick in. I tried above and I got
-EBADF as I did not pass initrd. Can you run gdb on kexec and see if
you are getting to syscall or run strace.

> 
> Another issue is that the syscall should allow load kernel only without initrd

Agreed. Currently my code is not handling it. I am thinking of ways how to
make passing initrd fd optional.

> 
> and
> cmdline since kernel can mount root and embed cmdline in itself.

Passing command line is already optional. I tried it and kexec loaded
successfully.

Thanks
Vivek
