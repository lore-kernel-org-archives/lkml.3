Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaFPRjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:39:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbaFPRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:39:08 -0400
Date: Mon, 16 Jun 2014 13:38:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: WANG Chao <chaowang@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140616173823.GC4515@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613124609.GC5871@redhat.com>
 <20140613153620.GG4751@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613153620.GG4751@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 05:36:20PM +0200, Borislav Petkov wrote:
> On Fri, Jun 13, 2014 at 08:46:09AM -0400, Vivek Goyal wrote:
> > If not, then we really can't do anything about it. A large memory
> > allocation will fail and user will get error.
> 
> Of course we can! You can't trust userspace and you need to check the
> values it gives you through the syscall.
> 
> And you need a sane default. The fact that I even have to state this
> explicitly...!

And what's the sane default in this case? Using current kernel's
command line size will not work if future kernel decide to support
even longer command line size.

> 
> So what if userspace gives a maximum value for which allocation
> succeeds? Does that mean that the kernel should blindly comply and
> allocate? Of course not! That would be dumb.

I agree that some kind of upper value is good. But I am disagreeing
that using current kernel's COMMAND_LINE_SIZE is better thing to do.

Also what's the upper limit on initramfs size? There is none. The issues
you are trying to prevent can be easily created simply by passing in
a large initrd file.

If we are not putting any sane defaults on size of kernel and initramfs, I
am not really sure what do we gain here by putting an incorrect limit
on kernel command line size.

> 
> > I disagree here. What if new kernel supports (2 * COMMAND_LINE_SIZE)
> > length command line. We don't want to truncate command line to smaller
> > size because running kernel does not support that long a command line.
> 
> Do you have a sensible use case where 2048 cmdline size (on x86) won't
> be enough and you really need it larger?

Who knows that in future we might have to extend it beyond 2048. You
can't say that 2048 wil never be changed. Nobody knows.

> 
> And even if this is a problem - which I seriously doubt - it would be
> problem with the 1st kernel too, not only with the kexec-ed one.

Why it will be a problem with first kernel?

So assuming that you will agree that we might have to extend kernel
command line some day, my question is how would you support kexec from
old kernel to newer kernel with larger command line size. (If I limit
support commnad line to the one supported by running kernel).

Thanks
Vivek
