Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaACOpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:45:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36716 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaACOpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:45:16 -0500
Date: Fri, 3 Jan 2014 09:44:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for grant driver
 (v2)
Message-ID: <20140103144409.GC27019@phenom.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com>
 <52C59483.5030607@citrix.com>
 <20140102185023.GG3021@pegasus.dumpdata.com>
 <52C6A4E5.3080904@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C6A4E5.3080904@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 11:54:13AM +0000, David Vrabel wrote:
> On 02/01/14 18:50, Konrad Rzeszutek Wilk wrote:
> > On Thu, Jan 02, 2014 at 04:32:03PM +0000, David Vrabel wrote:
> >> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> >>> @@ -1320,4 +1323,4 @@ static int __gnttab_init(void)
> >>>  	return gnttab_init();
> >>>  }
> >>>  
> >>> -core_initcall(__gnttab_init);
> >>> +core_initcall_sync(__gnttab_init);
> >>
> >> Why has this become _sync?
> > 
> > It needs to run _after_ the xen_pvh_gnttab_setup has run (which is
> > at gnttab_init):
> 
> 
> The use of core_initcall_sync() doesn't imply any ordering to me.  Can't

It has a clear ordering property.

> you call xen_pvh_gnttab_setup() from within __gnttab_init() ?

No. That is due to the fact that __gnttab_init() is in drivers/xen and is
also used by the ARM code.

Stefano in his previous review mentioned he would like PVH specific
code in arch/x86:

https://lkml.org/lkml/2013/12/18/507

> 
> David
