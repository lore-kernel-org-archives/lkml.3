Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaEZPeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:34:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:33459 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaEZPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:34:12 -0400
Message-Id: <20140526145605.016140154@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 26 May 2014 16:56:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/5] VM_PINNED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I mentioned at LSF/MM that I wanted to revive this, and at the time there were
no disagreements.

I finally got around to refreshing the patch(es) so here goes.

These patches introduce VM_PINNED infrastructure, vma tracking of persistent
'pinned' page ranges. Pinned is anything that has a fixed phys address (as
required for say IO DMA engines) and thus cannot use the weaker VM_LOCKED. One
popular way to pin pages is through get_user_pages() but that not nessecarily
the only way.

Roland, as said, I need some IB assistance, see patches 4 and 5, where I got
lost in the qib and ipath code.

Patches 1-3 compile tested.

