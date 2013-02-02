Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3BBAaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:30:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3BBA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:29:59 -0500
Date: Fri, 1 Feb 2013 16:29:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>, Linux MM <linux-mm@kvack.org>,
        David Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 6/9] mm/page_alloc: add informative debugging message in
 page_outside_zone_boundaries()
Message-Id: <20130201162957.3ec618cf.akpm@linux-foundation.org>
In-Reply-To: <20130201162848.74bdb2a7.akpm@linux-foundation.org>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
	<1358463181-17956-7-git-send-email-cody@linux.vnet.ibm.com>
	<20130201162848.74bdb2a7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013 16:28:48 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	if (ret)
> > +		pr_debug("page %lu outside zone [ %lu - %lu ]\n",
> > +			pfn, start_pfn, start_pfn + sp);
> > +
> >  	return ret;
> >  }
> 
> As this condition leads to a VM_BUG_ON(), "pr_debug" seems rather wimpy
> and I doubt if we need to be concerned about flooding the console.
> 
> I'll switch it to pr_err.

otoh, as nobody has ever hit that VM_BUG_ON() (yes?), do we really need
the patch?

