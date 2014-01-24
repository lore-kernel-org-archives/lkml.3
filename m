Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaAXStM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:49:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbaAXStL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:49:11 -0500
Date: Fri, 24 Jan 2014 13:48:57 -0500
From: Dave Jones <davej@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xensource.com
Subject: Re: Fix misplaced kfree from xlated_setup_gnttab_pages
Message-ID: <20140124184857.GA5062@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
	xen-devel@lists.xensource.com
References: <20140123064242.09E68660D05@gitolite.kernel.org>
 <20140124183114.GA31844@redhat.com>
 <20140124184655.GC16410@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124184655.GC16410@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 01:46:55PM -0500, Konrad Rzeszutek Wilk wrote:
 > Actually it should also be freed on the success path, as so:
 > 
 > I can squash it in, if you are OK with that?
 
Looks good to me.

thanks,

	Dave

 > diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
 > index 103c93f..c985835 100644
 > --- a/arch/x86/xen/grant-table.c
 > +++ b/arch/x86/xen/grant-table.c
 > @@ -162,14 +162,15 @@ static int __init xlated_setup_gnttab_pages(void)
 >  	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
 >  				    &xen_auto_xlat_grant_frames.vaddr);
 >  
 > -	kfree(pages);
 >  	if (rc) {
 >  		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
 >  			nr_grant_frames, rc);
 >  		free_xenballooned_pages(nr_grant_frames, pages);
 > +		kfree(pages);
 >  		kfree(pfns);
 >  		return rc;
 >  	}
 > +	kfree(pages);
 >  
 >  	xen_auto_xlat_grant_frames.pfn = pfns;
 >  	xen_auto_xlat_grant_frames.count = nr_grant_frames;

