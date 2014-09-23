Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbaIWXiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:38:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaIWXiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:38:17 -0400
Date: Tue, 23 Sep 2014 16:38:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Foley <pefoley2@pefoley.com>
Cc: ashutosh dixit <ashutosh.dixit@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Dutt, Sudeep" <sudeep.dutt@intel.com>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd
 builds for kernels < 3.13
Message-Id: <20140923163816.2f3cf938c7815424e55e444f@linux-foundation.org>
In-Reply-To: <CAOFdcFMLYJ9qqRB-uwyLwyBpa=KTsHMbzdANJrmRu_wrqNArOA@mail.gmail.com>
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
	<5421EA22.6000206@infradead.org>
	<ndhwbqvboe9c48.fsf@rasscmlmus001.pdx.intel.com>
	<CAOFdcFMLYJ9qqRB-uwyLwyBpa=KTsHMbzdANJrmRu_wrqNArOA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 19:23:39 -0400 Peter Foley <pefoley2@pefoley.com> wrote:

> On Tue, Sep 23, 2014 at 6:59 PM, ashutosh dixit
> <ashutosh.dixit@intel.com> wrote:
> > Correct, if things in Documentation will be compiled against the headers
> > in the kernel source tree then this patch is not required. However,
> > Andrew had reported the following compile error:
> >
> >> In file included from Documentation/mic/mpssd/sysfs.c:21:
> >> Documentation/mic/mpssd/mpssd.h:55:30: error: linux/virtio_ids.h: No such file or directory
> >
> > which made it appear to us that Documentation was being compiled against
> > headers installed on the system, not headers in the kernel source
> > tree. The patch was submitted to address this latter case, but if that
> > does not occur it is not required.
> >
> Alright, if you want to handle the case where somebody is trying to
> build against old and incompatible headers,
> just have a #error "Your kernel headers are too old, at least 3.13 is
> required" at the top of mpssd.c instead of having it fail at runtime.
> 

This build error is caused by compiling mpssd prior to `make
headers_install'.

There's really no reason to check the kernel version.  If someone
transplants mpssd out of its distributed kernel and into some older
kernel then a miscompile is their problem - their backport is
incomplete.
