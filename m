Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaAaOC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:02:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbaAaOCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:02:50 -0500
Date: Fri, 31 Jan 2014 15:04:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ben Guthro <benjamin.guthro@citrix.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        xen-devel@lists.xensource.com
Subject: Re: [BUG?] Interrupts enabled after
 xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
Message-ID: <20140131140451.GB7648@redhat.com>
References: <20140128150848.GA1428@redhat.com>
 <20140128160404.GA5732@phenom.dumpdata.com>
 <alpine.DEB.2.02.1401282120180.20167@chino.kir.corp.google.com>
 <20140129082521.GA1362@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129082521.GA1362@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 09:25:21AM +0100, Stanislaw Gruszka wrote:
> > Looks incomplete, what about the kzalloc() in 
> > xen_upload_processor_pm_data() and kcalloc()s in check_acpi_ids()?
> 
> Indeed and additionally from check_acpi_ids() we call
> acpi_walk_namespace(), which also take mutexes. Hence unfortunately
> making xen_upload_processor_pm_data() atomic is not easy, but possibly
> can be done by saving some data in memory after initialization.
> 
> Or perhaps this problem can be solved differently, by not using 
> yscore_ops->resume(), but some other resume callback from core, which
> allow to sleep. Than can require registering dummy device or sysfs
> class, but maybe there are simpler solutions.

Eventually work_struct could be used and scheduled from ->resume()
callback, if there is no dependency between uploading processor PM
data to hypervisor and other actions performed after
syscore_ops->resume();

Thanks
Stanislaw
