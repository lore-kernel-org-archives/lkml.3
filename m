Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaAHIUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:20:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49988 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaAHIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:20:08 -0500
Date: Wed, 8 Jan 2014 16:20:01 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave.hansen@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140108082000.GJ4106@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave.hansen@intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20140101002935.GA15683@localhost.localdomain>
 <52C5AA61.8060701@intel.com>
 <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
 <20140105003501.GC4106@localhost.localdomain>
 <20140106164604.GC27602@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106164604.GC27602@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010808-3532-0000-0000-0000048AEB6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 05:46:04PM +0100, Michal Hocko wrote:
> On Sun 05-01-14 08:35:01, Han Pingtian wrote:
> [...]
> > From f4d085a880dfae7638b33c242554efb0afc0852b Mon Sep 17 00:00:00 2001
> > From: Han Pingtian <hanpt@linux.vnet.ibm.com>
> > Date: Fri, 3 Jan 2014 11:10:49 +0800
> > Subject: [PATCH] mm: show message when raising min_free_kbytes in THP
> > 
> > min_free_kbytes may be raised during THP's initialization. Sometimes,
> > this will change the value being set by user. Showing message will
> > clarify this confusion.
> 
> I do not have anything against informing about changing value
> set by user but this will inform also when the default value is
> updated. Is this what you want? Don't you want to check against
> user_min_free_kbytes? (0 if not set by user)
> 

To use user_min_free_kbytes in mm/huge_memory.c, we need a 

    extern int user_min_free_kbytes;

in somewhere? Where should we put it? I guess it is mm/internal.h,
right?

Thanks.

