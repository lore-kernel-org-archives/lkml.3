Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaESPEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:04:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:12298 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaESPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:04:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,867,1392192000"; 
   d="scan'208";a="541499374"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
In-Reply-To: <20140519143837.GA5228@infradead.org>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140519150238.67898E009B@blue.fi.intel.com>
Date: Mon, 19 May 2014 18:02:38 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, May 19, 2014 at 05:35:40PM +0300, Kirill A. Shutemov wrote:
> > >From functional POV, emulation *should* be identical to original
> > remap_file_pages(), but slower. It would be nice, if you test it early.
> > 
> > It's not clear yet how long emulation will be there.
> 
> Stop right there.  We found out about two real life users of
> remap_file_pages() already, without even committing the patches to warn
> about using it to any tree.

Who is the second here?	Oracle?

> I think at this point the whole idea of removing the API should be dead
> on the floor, as we do not needlessly break userspace programs.

I'm fine if emulation will stay there for long time, but it's good idea
covert users to more standard API eariler where possible.

> If we can get rid of the ugly guts and provide a good enough emulation
> that the user won't cry I'd love to get rid of this cruft, but even
> that doesn't look certain yet.

And that's why I ask to test it.

-- 
 Kirill A. Shutemov
