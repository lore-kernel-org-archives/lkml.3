Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3G3PXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:23:49 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57909 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab3G3PXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:23:45 -0400
Date: Fri, 26 Jul 2013 09:42:51 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nivedita Singhvi <niv@us.ibm.com>, Michael J Wolf <mjwolf@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: new memory config sysfs driver for large
 memory systems
Message-ID: <20130726144251.GB4379@variantweb.net>
References: <1374786680-26197-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130725234007.GB18349@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725234007.GB18349@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073015-5490-0000-0000-000003E8C445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 04:40:07PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Jul 25, 2013 at 04:11:20PM -0500, Seth Jennings wrote:
> > +#define MEMFS_CLASS_NAME	"memoryfs"
> 
> One question, a "*fs" name in the kernel usually implies it is a
> separate filesystem, which this isn't at all, it's just a "normal"
> class/subsystem in the kernel.  So how about "memory" instead?

"memory" is the name used by the current sysfs memory layout code in
drivers/base/memory.c. So it can't be the same unless we are going to
create a toggle a boot time to select between the models, which is
something I am looking to add if this code/design is acceptable to
people.

The design is that people with large memory systems would pass a boot
parameter that selects this alternate layout, so that the majority
of non-large-memory users and any userspace programs that depend on the
old layout would be unaffected.

In the meantime, the name "memfs" was chosen for the RFC so that people
could compile and run the new model concurrently with the current model.

Seth

