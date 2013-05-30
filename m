Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab3E3PZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:25:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab3E3PZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:25:01 -0400
Date: Thu, 30 May 2013 11:00:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130530150030.GF2864@redhat.com>
References: <20130524152849.GF18218@redhat.com>
 <87mwrkatgu.fsf@xmission.com>
 <51A006CF.90105@gmail.com>
 <87k3mnahkf.fsf@xmission.com>
 <51A076FE.3060604@gmail.com>
 <20130525145217.0549138a@holzheu>
 <20130528135500.GC7088@redhat.com>
 <20130529135144.7f95c4c0@holzheu>
 <20130529162325.GD22146@redhat.com>
 <20130529191249.19a235be@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529191249.19a235be@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 07:12:49PM +0200, Michael Holzheu wrote:

[..]
> > > > So are you saying that s390 is ready to switch to mechanism of
> > > > creating ELF headers in first kernel by kexec-tools and new kernel
> > > > does not have to preare ELF headers?
> > > 
> > > No, I meant that currently nobody is using the kexec tools ELF
> > > header creation in the 1st kernel on s390. We create the ELF header
> > > in the 2nd kernel (mainly because of our cpuplugd issue).
> > > 
> > > Therefore, I think, we can safely change the ELF header creation in
> > > 2nd kernel to use your p_offset swap trick *and* we remove the swap
> > > code in the copy_oldmem_page() implementation (same kernel).
> > 
> > Ok. Got it. So s390 can fix it in kernel without creating any backward
> > compatibility issues (given the fact that nobody sees to be using
> > kexec-tools to build headers).
> > 
> > So please go ahead and fix it and that should solve your mmap() issue
> > too. Also please fix kexec-tools and that change will not be backward
> > compatible. 
> 
> Ok, I will do this.
> 
> I think we should add this "swap in ELF header" patch to the "kdump:
> Allow ELF header creation in new kernel" patch series (on top of the
> mmap patch series). Because when I remove the swap code from
> copy_oldmem_page(), the old trick to access the ELF header in the first
> kernel memory will no longer work.
> 
> Is that ok for you?

I am fine with both the patches in same series.

Thanks
Vivek
