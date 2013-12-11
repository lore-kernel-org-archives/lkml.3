Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3LKQid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:38:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3LKQi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:38:29 -0500
Date: Wed, 11 Dec 2013 11:38:09 -0500
From: Dave Jones <davej@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: oops in pgtable_trans_huge_withdraw
Message-ID: <20131211163809.GA26342@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	kirill.shutemov@linux.intel.com,
	Sasha Levin <sasha.levin@oracle.com>
References: <20131206210254.GA7962@redhat.com>
 <52A8877A.10209@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A8877A.10209@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 04:40:42PM +0100, Vlastimil Babka wrote:
 > On 12/06/2013 10:02 PM, Dave Jones wrote:
 > > I've spent a few days enhancing trinity's use of mmap's, trying to make it
 > > reproduce https://lkml.org/lkml/2013/12/4/499
 > 
 > FYI, I managed to reproduce that using trinity today,
 > trinity was from git at commit e8912cc which is from Dec 09 so I guess 
 > your enhancements were already there?

yep, everything I had pending is in HEAD now.

 > kernel was linux-next-20131209
 > I was running trinity -c mmap -c munmap -c mremap -c remap_file_pages -c 
 > mlock -c munlock
 
A shorthand for all those -c's is '-G vm'. (Though there might be a couple
extra syscalls in the list too, madvise, mprotect etc).

 > Now I'm running with Kirill's patch, will post results later.
 
Seemed to fix it for me, I've not reproduced that particular bug since applying it.
Kirill, is that on its way to Linus soon ?

thanks,

	Dave

