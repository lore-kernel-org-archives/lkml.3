Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaIPVZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaIPVZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:25:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
References: <cover.1410810247.git.milosz@adfin.com>
	<c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
	<x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
	<20140916210441.GC24591@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Sep 2014 17:24:29 -0400
In-Reply-To: <20140916210441.GC24591@infradead.org> (Christoph Hellwig's
	message of "Tue, 16 Sep 2014 14:04:41 -0700")
Message-ID: <x49wq93tg1e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

>> Again, the right return value for the O_DIRECT case is EINVAL.
>
> Is it?  We define -EAGAIN as it would block, which is defintively true
> for O_DIRECT reads.

It will *always* block.  So I don't think it's valid to ask for a
non-blocking read on a file opened with O_DIRECT.  What am I missing?

Cheers,
Jeff
