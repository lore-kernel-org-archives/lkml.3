Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaANURq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:17:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22627 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaANURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:17:43 -0500
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
	<20140114023346.GN9037@kmo> <yq161pnmcl2.fsf@sermon.lab.mkp.net>
	<20140114044841.GO9037@kmo>
Date: Tue, 14 Jan 2014 15:17:32 -0500
In-Reply-To: <20140114044841.GO9037@kmo> (Kent Overstreet's message of "Mon,
	13 Jan 2014 20:48:41 -0800")
Message-ID: <yq1ob3el3mr.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <kmo@daterainc.com> writes:

>> IOW, DISCARD, WRITE SAME and the impending COPY requests do not have
>> a 1:1 mapping between the block range worked on and the size of any
>> bvecs attached. Your recent changes must have changed the way we
>> handled that in the past.

Kent> Yeah - but with WRITE_SAME bios, wouldn't we at least have to
Kent> check that they're writing the same data to merge them?

We do. Check blk_write_same_mergeable().

-- 
Martin K. Petersen	Oracle Linux Engineering
