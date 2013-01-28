Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3A1PTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:19:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab3A1PTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:19:09 -0500
Date: Mon, 28 Jan 2013 10:16:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: zsmalloc: add gfp flags to zs_create_pool
Message-ID: <20130128151637.GC4838@konrad-lan.dumpdata.com>
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1359135978-15119-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130128033944.GB3321@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128033944.GB3321@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:39:44PM +0900, Minchan Kim wrote:
> Hi Seth,
> 
> On Fri, Jan 25, 2013 at 11:46:15AM -0600, Seth Jennings wrote:
> > zs_create_pool() currently takes a gfp flags argument
> > that is used when growing the memory pool.  However
> > it is not used in allocating the metadata for the pool
> > itself.  That is currently hardcoded to GFP_KERNEL.
> > 
> > zswap calls zs_create_pool() at swapon time which is done
> > in atomic context, resulting in a "might sleep" warning.
> > 
> > This patch changes the meaning of the flags argument in
> > zs_create_pool() to mean the flags for the metadata allocation,
> > and adds a flags argument to zs_malloc that will be used for
> > memory pool growth if required.
> 
> As I mentioned, I'm not strongly against with this patch but it
> should be last resort in case of not being able to address
> frontswap's init routine's dependency with swap_lock.
> 
> I sent a patch and am waiting reply of Konrand or Dan.
> If we can fix frontswap, it would be better rather than
> changing zsmalloc.

Could you point me to the subject/title of it please? Thanks.
