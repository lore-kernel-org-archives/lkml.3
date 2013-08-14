Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419Ab3HNToU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:44:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760328Ab3HNTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:49 -0400
Date: Wed, 14 Aug 2013 12:43:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@sr71.net>, Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
Message-ID: <20130814194348.GB10469@kroah.com>
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 02:31:45PM -0500, Seth Jennings wrote:
> Large memory systems (~1TB or more) experience boot delays on the order
> of minutes due to the initializing the memory configuration part of
> sysfs at /sys/devices/system/memory/.

Are you sure that is the problem area?  Have you run perf on it?

> ppc64 has a normal memory block size of 256M (however sometimes as low
> as 16M depending on the system LMB size), and (I think) x86 is 128M.  With
> 1TB of RAM and a 256M block size, that's 4k memory blocks with 20 sysfs
> entries per block that's around 80k items that need be created at boot
> time in sysfs.  Some systems go up to 16TB where the issue is even more
> severe.

The x86 developers are working with larger memory sizes and they haven't
seen the problem in this area, for them it's in other places, as I
referred to in my other email.

> This patch provides a means by which users can prevent the creation of
> the memory block attributes at boot time, yet still dynamically create
> them if they are needed.
> 
> This patch creates a new boot parameter, "largememory" that will prevent
> memory_dev_init() from creating all of the memory block sysfs attributes
> at boot time.  Instead, a new root attribute "show" will allow
> the dynamic creation of the memory block devices.
> Another new root attribute "present" shows the memory blocks present in
> the system; the valid inputs for the "show" attribute.

You never documented any of these abi changes, which is a requirement
(not that I'm agreeing that a boot parameter is ok...)

> There was a significant amount of refactoring to allow for this but
> IMHO, the code is much easier to understand now.

Care to refactor things first, with no logical changes, and then make
your changes in a follow-on patch, so that people can actually find what
you changed in the patch?

Remember, a series of patches please, not one big "refactor and change
it all" patch.

thanks,

greg k-h
