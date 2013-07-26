Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3G3PYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:24:48 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47237 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3G3PXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:23:46 -0400
Date: Fri, 26 Jul 2013 09:33:44 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nivedita Singhvi <niv@us.ibm.com>, Michael J Wolf <mjwolf@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: new memory config sysfs driver for large
 memory systems
Message-ID: <20130726143344.GA4379@variantweb.net>
References: <1374786680-26197-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130725233800.GA18349@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725233800.GA18349@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073015-9574-0000-0000-000008F3DECB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 04:38:00PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Jul 25, 2013 at 04:11:20PM -0500, Seth Jennings wrote:
> > From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> > 
> > Large memory systems (1TB or more) experience boot delays on the order
> > of minutes due to the initializing the memory configuration part of
> > sysfs at /sys/devices/system/memory/.
> > 
> > ppc64 has a memory block size of 256M and (I think) x86 is 128M.  With 1TB
> > of RAM and a 256M block size, that's 4k memory blocks with 20 sysfs
> > entries per block that's around 80k items that need be created at boot
> > time in sysfs.  Some systems go up to 16TB where the issue is
> > even more severe.
> > 
> > This patch is a prototype for a new sysfs memory layout where the
> > entries are created on demand by writing memory block numbers into a
> > "show" and "hide" files to create and destroy the memory block
> > configuration attributes in sysfs.  This would decouple the number of
> > sysfs entries created at boot time from the memory size, resulting in a
> > sysfs initialization time that doesn't increase and memory size
> > increase.
> > 
> > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> 
> How does this tie into the patches Nathan sent yesterday for memory
> hotplug stuff that I thought modified the same part of the kernel?

So this patch introduces the new layout in a new file
drives/base/memfs.c (which, in light of your last comment should
probably be something more like largememory.c).

It doesn't clash with Nathan's, but it doesn't contain the new
is_memblock_[removable|offline] functions or the new "release"
attribute.  But that can be added easily.

Seth

