Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaCJMj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaCJMjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:39:24 -0400
Date: Mon, 10 Mar 2014 08:38:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, calgary: use 8M TCE table size by default
Message-ID: <20140310123848.GA31879@redhat.com>
References: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
 <20140307141413.GF1326@redhat.com>
 <20140307155204.GC30641@dhcp-17-89.nay.redhat.com>
 <20140307160906.GH1326@redhat.com>
 <20140310083834.GA32547@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310083834.GA32547@dhcp-17-89.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:38:34PM +0800, WANG Chao wrote:

[..]
> > So we have two scenarios.
> > 
> > - Old first kernel and new second kernel.
> > - New first kernel and old second kernel.
> > 
> > If we want to make these two scenarios work with calgary, we need to
> > use kexec-tools with --pass-memmap option. And also in new kernel we
> > need to retain saved_max_pfn. Only difference will be, that we will
> > set saved_max_pfn only if it is kdump kernel and if user passed a 
> > memory map on kernel command line.
> 
> Old first kernel and new second kernel is easy to handle. Like you said,
> we can use exactmap and set saved_max_pfn in kdump kernel, just as the
> old way.
> 
> But it's still not clear to me how we can handle the case of new first
> kernel and old second kernel.
> 
> Let's say, a calgary system has 2G memory. The new first kernel TCE
> table size are hard coded to 8M. When the old kdump kernel is booting,
> memmap=exactmap is parsed and saved_max_pfn is set to 2G/PAGE_SIZE. TCE
> table size is determined by 2G ram size. So the size is 4M. We run into
> the situation that TCE table is 8M in first kernel and 4M in second
> kernel. This inconsistency of TCE table size would cause kdump kernel
> fails somehow, that's why we brought in saved_max_pfn in the first place
> as you know.
> 
> The problem is how to keep TCE table size being consistent between new
> first kernel and old second kernel.

You are right. I did not think through it. So we can't handle the case
of new first kernel and second old kernel without exporting size of
tables to user space. Given the fact that calgary is old hardware,
exporting table size to user space is not very prudent.

I would say let us handle the case of old first kernel and second new
kernel to maintain backward compatibility.

Thanks
Vivek
