Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966525AbaFRMlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:41:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966138AbaFRMlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:41:24 -0400
Date: Wed, 18 Jun 2014 08:40:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, jkosina@suse.cz, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140618124037.GB15327@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140612054203.GA3696@darkstar.nay.redhat.com>
 <20140617142419.GC28340@redhat.com>
 <20140618014510.GA2851@darkstar.nay.redhat.com>
 <20140618015246.GB2851@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618015246.GB2851@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:52:46AM +0800, Dave Young wrote:
[..]
> > > > Hi, Vivek
> > > > 
> > > > For efi ioremapping case, in 3.15 kernel efi runtime maps will not be saved
> > > > if efi=old_map is used. So you need detect this and fail the kexec file load.
> > > 
> > > Dave,
> > > 
> > > Instead of failing kexec load in case of efi=old_map, I think it will be
> > > better to just not pass runtime map in bootparams. That way user can
> > > pass "noefi" on commandline and kdump should still work.  (Like it works
> > > with user space implementation).
> 
> BTW, in kexec-tools in case old_map it just does not fill efi_info so 2nd kernel
> will automaticlly switch to noefi boot. So do same in kernel make sense as well.

Yep. If old_map is being used, I will not fill efi_info and I will also
not pass efi setup data structure. I think user space does the same.

> 
> In userspace tools we pass acpi_rsdp for kdump noefi case, do you want to add that
> in the kernel loader?

I will not do that in kernel. I will expect user space to pass in
acpi_rsdp=0x on command line.

Thanks
Vivek
