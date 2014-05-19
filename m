Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaESPSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:18:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:36442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaESPSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="514107442"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
In-Reply-To: <20140519151104.GA16736@infradead.org>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <20140519150238.67898E009B@blue.fi.intel.com>
 <20140519151104.GA16736@infradead.org>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140519151758.A2162E009B@blue.fi.intel.com>
Date: Mon, 19 May 2014 18:17:58 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, May 19, 2014 at 06:02:38PM +0300, Kirill A. Shutemov wrote:
> > > Stop right there.  We found out about two real life users of
> > > remap_file_pages() already, without even committing the patches to warn
> > > about using it to any tree.
> > 
> > Who is the second here?	Oracle?
> 
> PyPy.
> 
> Oracle would be the third, although use of the feature is optional and
> fairly hard to opt in to, so I didn't count it.

IIUC PyPy uses the syscall in some early prototype and looks like guys are
okay to rework it to mmap() if default sysctl_max_map_count will be high
enough.

-- 
 Kirill A. Shutemov
