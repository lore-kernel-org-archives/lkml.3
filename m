Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3KVCE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:04:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab3KVCEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:04:24 -0500
Date: Thu, 21 Nov 2013 21:03:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131122020353.GC31921@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <528EAB73.9010700@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528EAB73.9010700@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:55:15AM +0900, HATAYAMA Daisuke wrote:
> (2013/11/21 2:50), Vivek Goyal wrote:
> >Current proposed secureboot implementation disables kexec/kdump because
> >it can allow unsigned kernel to run on a secureboot platform. Intial
> >idea was to sign /sbin/kexec binary and let that binary do the kernel
> >signature verification. I had posted RFC patches for this apparoach
> >here.
> >
> >https://lkml.org/lkml/2013/9/10/560
> >
> >Later we had discussion at Plumbers and most of the people thought
> >that signing and trusting /sbin/kexec is becoming complex. So a
> >better idea might be let kernel do the signature verification of
> >new kernel being loaded. This calls for implementing a new system call
> >and moving lot of user space code in kernel.
> >
> >kexec_load() system call allows loading a kexec/kdump kernel and jump
> >to that kernel at right time. Though a lot of processing is done in
> >user space which prepares a list of segments/buffers to be loaded and
> >kexec_load() works on that list of segments. It does not know what's
> >contained in those segments.
> >
> >Now a new system call kexec_file_load() is implemented which takes
> >kernel fd and initrd fd as parameters. Now kernel should be able
> >to verify signature of newly loaded kernel.
> >
> >This is an early RFC patchset. I have not done signature handling
> >part yet. This is more of a minimal patch to show how new system
> >call and functionality will look like. Right now it can only handle
> >bzImage with 64bit entry point on x86_64. No EFI, no x86_32  or any
> >other architecture. Rest of the things can be added slowly as need
> >arises. In first iteration, I have tried to address most common use case
> >for us.
> >
> >Any feedback is welcome.
> >
> 
> So, ultimately on this design direction, user-land kexec command someday
> will no longer be used at all? Or is there any feature you will keep in
> user-land side?
> 

Current user land is huge and implements lots of image formats on
differnt architectures with tons of options. 

I doubt that kernel implementation will be a complete replacement of
existing implementation anytime soon.  If kernel implementation works
well, then may be in future at some point of time we can completely
move away from user space implementation.

Thanks
Vivek
