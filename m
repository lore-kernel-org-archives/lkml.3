Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaBZKXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:23:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaBZKXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:23:52 -0500
Date: Wed, 26 Feb 2014 11:26:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Rientjes <rientjes@google.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ben Guthro <benjamin.guthro@citrix.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        xen-devel@lists.xensource.com
Subject: Re: [BUG?] Interrupts enabled after
 xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
Message-ID: <20140226102620.GA4686@redhat.com>
References: <20140128150848.GA1428@redhat.com>
 <20140128160404.GA5732@phenom.dumpdata.com>
 <alpine.DEB.2.02.1401282120180.20167@chino.kir.corp.google.com>
 <20140129082521.GA1362@redhat.com>
 <20140131160140.GC23648@phenom.dumpdata.com>
 <20140203101215.GA1725@redhat.com>
 <20140203141429.GD3400@phenom.dumpdata.com>
 <20140210143727.GA15771@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210143727.GA15771@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 09:37:27AM -0500, Konrad Rzeszutek Wilk wrote:
> > > But I'm not sure if that is good solution. It crate some not necessery
> > > sysfs directories and files. Additionaly it can restore CPU C-states
> > > after some other drivers resume, which prehaps require proper C-states.
> > 
> > Yes.
> > > 
> > > Hence maybe adding direct notify from xen core resume will be better
> > > idea (proposed patch below). Plese let me know what you think, I'll
> > > provide solution which you choose to bug reporters for testing.
> > 
> > Let me think about it for a day or so.
> 
> Sorry for the delay. I think this is fine.

I'm sorry for delay too. I provided test kernel with the patch to bug
reporter, but have not get any answer since two weeks now.

I'll post the patch in the next email, I hope someone can test it (I'm
not xen user). I'm pretty sure it fixes the problem, but not sure if it
does not cause some crash. To test is enough to perform suspend/resume
cycle (thought I'm not sure if suspended should be just guest or whole
system with hypervisor).

Thanks
Stanislaw
