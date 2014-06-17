Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbaFQOZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:25:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585AbaFQOZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:25:02 -0400
Date: Tue, 17 Jun 2014 10:24:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, jkosina@suse.cz, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140617142419.GC28340@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140612054203.GA3696@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612054203.GA3696@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 01:42:03PM +0800, Dave Young wrote:
> On 06/03/14 at 09:06am, Vivek Goyal wrote:
> > Hi,
> > 
> > This is V3 of the patchset. Previous versions were posted here.
> > 
> > V1: https://lkml.org/lkml/2013/11/20/540
> > V2: https://lkml.org/lkml/2014/1/27/331
> > 
> > Changes since v2:
> > 
> > - Took care of most of the review comments from V2.
> > - Added support for kexec/kdump on EFI systems.
> > - Dropped support for loading ELF vmlinux.
> > 
> > This patch series is generated on top of 3.15.0-rc8. It also requires a
> > two patch cleanup series which is sitting in -tip tree here.
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=x86/boot
> > 
> > This patch series does not do kernel signature verification yet. I plan
> > to post another patch series for that. Now bzImage is already signed
> > with PKCS7 signature I plan to parse and verify those signatures.
> > 
> > Primary goal of this patchset is to prepare groundwork so that kernel
> > image can be signed and signatures be verified during kexec load. This
> > should help with two things.
> > 
> > - It should allow kexec/kdump on secureboot enabled machines.
> > 
> > - In general it can help even without secureboot. By being able to verify
> >   kernel image signature in kexec, it should help with avoiding module
> >   signing restrictions. Matthew Garret showed how to boot into a custom
> >   kernel, modify first kernel's memory and then jump back to old kernel and
> >   bypass any policy one wants to.
> > 
> > Any feedback is welcome.
> 
> Hi, Vivek
> 
> For efi ioremapping case, in 3.15 kernel efi runtime maps will not be saved
> if efi=old_map is used. So you need detect this and fail the kexec file load.

Dave,

Instead of failing kexec load in case of efi=old_map, I think it will be
better to just not pass runtime map in bootparams. That way user can
pass "noefi" on commandline and kdump should still work.  (Like it works
with user space implementation).

What do you think?

Thanks
Vivek
