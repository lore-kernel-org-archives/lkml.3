Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab3GBFsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:48:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49857 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab3GBFsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:48:22 -0400
Date: Tue, 2 Jul 2013 14:06:56 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: madvise: MADV_POPULATE for quick pre-faulting
Message-ID: <20130702060655.GA3924@gmail.com>
Mail-Followup-To: Dave Hansen <dave@sr71.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20130627231605.8F9F12E6@viggo.jf.intel.com>
 <20130628054757.GA10429@gmail.com>
 <51CDB056.5090308@sr71.net>
 <51CE4451.4060708@gmail.com>
 <51D1AB6E.9030905@sr71.net>
 <20130702023748.GA10366@gmail.com>
 <51D25A71.3060007@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D25A71.3060007@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 09:43:29PM -0700, Dave Hansen wrote:
> On 07/01/2013 07:37 PM, Zheng Liu wrote:
> > FWIW, it would be great if we can let MAP_POPULATE flag support shared
> > mappings because in our product system there has a lot of applications
> > that uses mmap(2) and then pre-faults this mapping.  Currently these
> > applications need to pre-fault the mapping manually.
> 
> Are you sure it doesn't?  From a cursory look at the code, it looked to
> me like it would populate anonymous and file-backed, but I didn't
> double-check experimentally.

Thanks for pointing it out. I write a program to test this issue, and it
seems to me that it can populate a shared mapping.  But in manpage it
describes as below:

MAP_POPULATE (since Linux 2.5.46)
    Populate (prefault) page tables for a mapping.  For a file mapping,
    this causes read-ahead on the file.  Later accesses to the mapping
    will not be blocked by page faults.  MAP_POPULATE is only supported
    for private mappings since Linux 2.6.23.

This page is part of release 3.24 of the Linux man-pages project.  I am
not sure whether it has been updated or not.

Regards,
                                                - Zheng
