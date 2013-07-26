Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3GZKmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab3GZKmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:42:17 -0400
Message-ID: <51F25277.6070704@redhat.com>
Date: Fri, 26 Jul 2013 12:41:59 +0200
From: Jan Vesely <jvesely@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org
CC: Kent Overstreet <koverstreet@google.com>, Rob Evers <revers@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>,
        Nikola Pajkovsky <npajkovs@redhat.com>,
        Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Don Howard <dhoward@redhat.com>,
        jano.vesely@gmail.com
Subject: Re: [PATCH v4 0/2] block: Fix regression since 46081b166415acb66d4b3150ecefcd9460bb48a1
 (was: Allow merging of tail pages into the last segment)
References: <1373644343-6671-1-git-send-email-jvesely@redhat.com>
In-Reply-To: <1373644343-6671-1-git-send-email-jvesely@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/13 17:52, Jan Vesely wrote:
> Hi
> 
> These patches modify __bio_add_page to accept pages that extent the last bio
> segment. some drivers craft their buffers and rely on this behavior (see
> message in patch 2 for details)
> 
> 
> jan
> 
> v4: whitespace fixes to make checkpatch happy
> 
> v3: Use code from __blk_recalc_rq_segments to decide whether the page is
>     mergeable, 
> 
> v2: modify a comment

ping
and a bit more info from patch 2/2:

The original behavior was to refuse all pages after the maximum number of
segments has been reached. However, some drivers (like st) craft their buffers
to potentially require exactly max segments and multiple pages in the last
segment. This patch modifies the check to allow pages that can be merged into
the last segment.

Fixes EBUSY failures when using large tape block size in high
memory fragmentation condition. This regression was introduced by commit
46081b166415acb66d4b3150ecefcd9460bb48a1
st: Increase success probability in driver buffer allocation

Jan

-- 
Jan Vesely <jvesely@redhat.com>
