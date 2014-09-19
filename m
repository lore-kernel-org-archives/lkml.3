Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbaISOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbaISOJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:09:24 -0400
Date: Fri, 19 Sep 2014 09:22:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: CAI Qian <caiqian@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        ltp-list <ltp-list@lists.sourceforge.net>,
        crash-utility <crash-utility@redhat.com>,
        kexec <kexec@lists.infradead.org>,
        kexec kdump redhat mailing list 
	<kexec-kdump-list@redhat.com>
Subject: Re: [RFC] autokdump - automated kdump testsuite
Message-ID: <20140919132236.GB2190@redhat.com>
References: <145412866.25258463.1411119061796.JavaMail.zimbra@redhat.com>
 <293476264.25264480.1411120345360.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <293476264.25264480.1411120345360.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 05:52:25AM -0400, CAI Qian wrote:
> I plan to release an automated kdump testsuite that will be

So will this be a standalone test suit? Can it be merged with
something already existing say, LTP.

> focus on testing kernel and the crash utility. It should work
> for all major distros since it will use none of distro-specific
> stuff, and also support different arches including x86, ARM,
> PPC64 and s390x.
> 
> It does the following:
> 1) check if there is a memory reserved for kdump. If not,
>    reserve the memory and reboot the system.
> 2) once the system is back, load kexec on panic and
>    prepare a separate initramfs that including needed
>    modules to load a local filesystem and necessary utilities

So you will write logic to prepare custom initramfs or will rely
on dracut or some other utility for that.

>    in order to analyse /proc/vmcore in the 2nd kernel.
> 3) trigger the system crash using methods like sysrq-c, NMI,
>    and panic_on_hung_task etc.
> 4) in the 2nd kernel, mount a filesystem and use the crash
>    utility to analyse /proc/vmcore. Then, gather the analyse
>    logs, serial console output, dmesg etc into the filesystem.

Why not save core and boot back in first kernel and then analyze. 

Trying to work directly with /proc/vmcore does not test makedumfile
which everybody uses. Also it will require more memory to be reserved
and packing crash and debug vmlinux into initramfs.

I think being able to test makedumpfile also is the key here.

Thanks
Vivek 
> 5) reboot back into the 1st kernel.
> 
> implementation:
> It will setup a daemon to handle reboots.
> 
> plan:
> I might also to test the makedumpfile all together later.
>    CAI Qian
