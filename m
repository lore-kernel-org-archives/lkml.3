Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaCGQJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:09:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaCGQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:09:37 -0500
Date: Fri, 7 Mar 2014 11:09:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, calgary: use 8M TCE table size by default
Message-ID: <20140307160906.GH1326@redhat.com>
References: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
 <20140307141413.GF1326@redhat.com>
 <20140307155204.GC30641@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307155204.GC30641@dhcp-17-89.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:52:04PM +0800, WANG Chao wrote:
> Hi, Vivek
> 
> On 03/07/14 at 09:14am, Vivek Goyal wrote:
> > On Fri, Mar 07, 2014 at 04:10:16PM +0800, WANG Chao wrote:
> > 
> > [..]
> > >  	}
> > >  
> > > -	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
> > > -					saved_max_pfn : max_pfn) * PAGE_SIZE);
> > > +	specified_table_size = determine_tce_table_size();
> > 
> > I don't think you can get rid of saved_max_pfn right away. What if
> > somebody is using old first kernel and new second kernel. Then old kernel
> > will still be using a table size which is smaller than 8M.
> 
> If TCE table size is hard coded to 8M, the new 1st kernel can never be
> compatible with the old 2nd kernel.

I gave example of old first kernel and new second kernel, and not
vice-versa.

So we have two scenarios.

- Old first kernel and new second kernel.
- New first kernel and old second kernel.

If we want to make these two scenarios work with calgary, we need to
use kexec-tools with --pass-memmap option. And also in new kernel we
need to retain saved_max_pfn. Only difference will be, that we will
set saved_max_pfn only if it is kdump kernel and if user passed a 
memory map on kernel command line.

So it is doable if it want to do it.

Now the real question is, is it worth introducing all this complication
and confusion given the fact most of the people use same first and second
kernel and given the fact that calgary is old hardware. What are the
chances somebody will run into it.

I would say it is not very complicated to maintain backward compatibility
in this case. So let us keep saved_max_pfn for some time and make
kexec-tools changes. Some time down the line, one can get rid of
saved_max_pfn completely.

Thanks
Vivek
