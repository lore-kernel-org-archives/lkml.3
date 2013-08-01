Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3HAU4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:56:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3HAU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:56:09 -0400
Date: Fri, 2 Aug 2013 04:57:24 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nivedita Singhvi <niv@us.ibm.com>, Michael J Wolf <mjwolf@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: new memory config sysfs driver for large
 memory systems
Message-ID: <20130801205724.GA13585@kroah.com>
References: <1374786680-26197-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130725234007.GB18349@kroah.com>
 <20130726144251.GB4379@variantweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726144251.GB4379@variantweb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 09:42:51AM -0500, Seth Jennings wrote:

Sorry for the delay, google decided to mark your responses as "spam" :(

> On Thu, Jul 25, 2013 at 04:40:07PM -0700, Greg Kroah-Hartman wrote:
> > On Thu, Jul 25, 2013 at 04:11:20PM -0500, Seth Jennings wrote:
> > > +#define MEMFS_CLASS_NAME	"memoryfs"
> > 
> > One question, a "*fs" name in the kernel usually implies it is a
> > separate filesystem, which this isn't at all, it's just a "normal"
> > class/subsystem in the kernel.  So how about "memory" instead?
> 
> "memory" is the name used by the current sysfs memory layout code in
> drivers/base/memory.c. So it can't be the same unless we are going to
> create a toggle a boot time to select between the models, which is
> something I am looking to add if this code/design is acceptable to
> people.

I know it can't be the same, but this is like "memory_v2" or something,
right?  I suggest you make it an either/or option, given that you feel
the existing layout just will not work properly for you.

> The design is that people with large memory systems would pass a boot
> parameter that selects this alternate layout, so that the majority
> of non-large-memory users and any userspace programs that depend on the
> old layout would be unaffected.
> 
> In the meantime, the name "memfs" was chosen for the RFC so that people
> could compile and run the new model concurrently with the current model.

It's a really bad name for a driver subsystem, please don't use it.

thanks,

greg k-h
