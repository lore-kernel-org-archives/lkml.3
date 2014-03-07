Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaCGPwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:52:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaCGPwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:52:37 -0500
Date: Fri, 7 Mar 2014 23:52:04 +0800
From: WANG Chao <chaowang@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, calgary: use 8M TCE table size by default
Message-ID: <20140307155204.GC30641@dhcp-17-89.nay.redhat.com>
References: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
 <20140307141413.GF1326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307141413.GF1326@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek

On 03/07/14 at 09:14am, Vivek Goyal wrote:
> On Fri, Mar 07, 2014 at 04:10:16PM +0800, WANG Chao wrote:
> 
> [..]
> >  	}
> >  
> > -	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
> > -					saved_max_pfn : max_pfn) * PAGE_SIZE);
> > +	specified_table_size = determine_tce_table_size();
> 
> I don't think you can get rid of saved_max_pfn right away. What if
> somebody is using old first kernel and new second kernel. Then old kernel
> will still be using a table size which is smaller than 8M.

If TCE table size is hard coded to 8M, the new 1st kernel can never be
compatible with the old 2nd kernel. Because old kernel's TCE table size
is depending on saved_max_pfn, which could be from 64K to 8M, not
necessarily the hard coded value 8M.

If we want to drop saved_max_pfn once and for all, that's a trade-off
which is worth doing. Because as Muli pointed out last time, there are
very few people likely running upstream kernel on calgary machine.  And
most of them would use the same kernel as 1st and 2nd kernel. For the
very very few people who suffers from it, we can always encourage them
to use the same kernel for 1st and 2nd kernel or other solutions we
have.

Thanks
WANG Chao
