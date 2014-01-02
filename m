Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaABV65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:58:57 -0500
Received: from mail-gg0-f173.google.com ([209.85.161.173]:59895 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaABV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:58:55 -0500
Date: Thu, 2 Jan 2014 13:58:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@intel.com>
cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
In-Reply-To: <52C5AA61.8060701@intel.com>
Message-ID: <alpine.DEB.2.02.1401021357360.21537@chino.kir.corp.google.com>
References: <20140101002935.GA15683@localhost.localdomain> <52C5AA61.8060701@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014, Dave Hansen wrote:

> > min_free_kbytes may be updated during thp's initialization. Sometimes,
> > this will change the value being set by user. Showing message will
> > clarify this confusion.
> ...
> > -	if (recommended_min > min_free_kbytes)
> > +	if (recommended_min > min_free_kbytes) {
> >  		min_free_kbytes = recommended_min;
> > +		pr_info("min_free_kbytes is updated to %d by enabling transparent hugepage.\n",
> > +			min_free_kbytes);
> > +	}
> 
> "updated" doesn't tell us much.  It's also kinda nasty that if we enable
> then disable THP, we end up with an elevated min_free_kbytes.  Maybe we
> should at least put something in that tells the user how to get back
> where they were if they care:
> 

The default value of min_free_kbytes depends on the implementation of the 
VM regardless of any config options that you may have enabled.  We don't 
specify what the non-thp default is in the kernel log, so why do we need 
to specify what the thp default is?
