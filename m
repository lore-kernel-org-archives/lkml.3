Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaESOin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:38:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaESOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:38:42 -0400
Date: Mon, 19 May 2014 07:38:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Kenny Simpson <theonetruekenny@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Subject: Re: remap_file_pages() use
Message-ID: <20140519143837.GA5228@infradead.org>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519143540.BE9F6E009B@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:35:40PM +0300, Kirill A. Shutemov wrote:
> >From functional POV, emulation *should* be identical to original
> remap_file_pages(), but slower. It would be nice, if you test it early.
> 
> It's not clear yet how long emulation will be there.

Stop right there.  We found out about two real life users of
remap_file_pages() already, without even committing the patches to warn
about using it to any tree.

I think at this point the whole idea of removing the API should be dead
on the floor, as we do not needlessly break userspace programs.

If we can get rid of the ugly guts and provide a good enough emulation
that the user won't cry I'd love to get rid of this cruft, but even
that doesn't look certain yet.

