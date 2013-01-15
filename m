Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3AOU7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:59:54 -0500
Received: from [205.170.118.184] ([205.170.118.184]:43043 "EHLO
	bubbles.rockgeek.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757147Ab3AOU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:59:52 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 15:59:52 EST
Date: Tue, 15 Jan 2013 13:50:41 -0700
From: John McCorquodale <mcq@rockgeek.org>
To: linux-kernel@vger.kernel.org
Subject: Transparent Hugepage Nit
Message-ID: <20130115205041.GA12113@rockgeek.org>
Reply-To: John McCorquodale <mcq@rockgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose a hugepage-aligned mmap(MAP_ANONYMOUS) mapping has been madvise()d
HUGEPAGE.  If a subeqeuent call to mremap() grows the mapping and has to
move the mapping, the hugepage-alignment is not preserved in the choice of 
new address (in 3.7.2).

I can workaround this by doing a 1-hugepage-oversized remap to find a new 
aligned address and then size it back down MREMAP_FIXED, but that's probably 
a lot of frags to 4k pages and back that aren't necessary.

Should it not be the case that mremap(MAYMOVE) on something advised hugepage
ALWAYS chooses a hugepage-aligned address?  This would be handy when doing the
initial allocation too: mmap, madvise, mremap (to the same size) to get
alignment.

Cheers,

-mcq
