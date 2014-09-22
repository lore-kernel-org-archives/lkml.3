Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaIVPt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaIVPtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:49:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>,
        Andreas Dilger <adilger@dilger.ca>, Milosz Tanski <milosz@adfin.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio\@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
References: <cover.1410810247.git.milosz@adfin.com>
	<8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
	<94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
	<20140919112147.GA4639@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Sep 2014 11:48:35 -0400
In-Reply-To: <20140919112147.GA4639@infradead.org> (Christoph Hellwig's
	message of "Fri, 19 Sep 2014 04:21:47 -0700")
Message-ID: <x49tx3zpsfg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Without the atomic WRITE SCATTERED use case adding the syscalls seems
> rather pointless, and I'd really avoid blocking nice software only
> features like the per-I/O nonblock flag (and the similarly trivial
> per-I/O sync option I have a prototype for) on it.

Andreas and Zach pointed out that the scatter/gather system calls also
help network file systems.  I'm not yet sure how much work it would be,
but it certainly seems worth considering readx/writex (or whatever we
want to call them) to avoid needlessly adding a ton of system calls.

Cheers,
Jeff
