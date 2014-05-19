Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaESPxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:53:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:45381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbaESPxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:53:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="514130448"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Armin Rigo <arigo@tunes.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <CAMSv6X1-17HMTO=b6QOZA0Xm1combFxV4wuX1gPMUqC02EKrJA@mail.gmail.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <20140519150238.67898E009B@blue.fi.intel.com>
 <20140519151104.GA16736@infradead.org>
 <20140519151758.A2162E009B@blue.fi.intel.com>
 <CAMSv6X1-17HMTO=b6QOZA0Xm1combFxV4wuX1gPMUqC02EKrJA@mail.gmail.com>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140519155336.86E93E009B@blue.fi.intel.com>
Date: Mon, 19 May 2014 18:53:36 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Armin Rigo wrote:
> Hi Kirill,
> 
> On 19 May 2014 17:17, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > IIUC PyPy uses the syscall in some early prototype and looks like guys are
> > okay to rework it to mmap() if default sysctl_max_map_count will be high
> > enough.
> 
> Yes, we can switch easily if needed.  The syscall is not in any
> "production" version yet.
> 
> Please note that "high enough" in this context means higher than
> 2**20.  We need it high enough to handle regularly 10-20% of all the
> RAM used by each program.  If I count correctly, at 20%, 2**20 fails
> above 20GB.  In general I would suggest to use a default limit that
> depends on the amount of RAM (+swap) available.

Is it nessesary to remap in 4k chunks for you?
What about 64k chunks? Or something bigger?

This way you can scale down required number of VMAs to something more
reasonable.

-- 
 Kirill A. Shutemov
