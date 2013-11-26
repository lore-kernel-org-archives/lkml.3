Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab3KZTCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:02:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56130 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3KZTCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:02:53 -0500
Message-ID: <5294F030.5090805@kernel.dk>
Date: Tue, 26 Nov 2013 12:02:08 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: build warnings after merge of the block tree
References: <20131126132946.e402679788ae8269f0c5128a@canb.auug.org.au>	<20131126143550.7a2195476ff4aa5c73db20b2@canb.auug.org.au> <CAOesGMiPpetDRt7dfHvcZ3LTSYyR3CBj2L2kq=pBMamkzCbb3A@mail.gmail.com>
In-Reply-To: <CAOesGMiPpetDRt7dfHvcZ3LTSYyR3CBj2L2kq=pBMamkzCbb3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 12:01 PM, Olof Johansson wrote:
> On Mon, Nov 25, 2013 at 7:35 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> On Tue, 26 Nov 2013 13:29:46 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> After merging the block tree, today's linux-next build (arm
>>> multi_v7_defconfig) produced these warnings:
>>>
>>> block/blk-merge.c: In function 'blk_rq_map_sg':
>>> block/blk-merge.c:133:8: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:171:23: note: 'bvprv.bv_len' was declared here
>>> block/blk-merge.c:133:8: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:171:23: note: 'bvprv.bv_page' was declared here
>>> block/blk-merge.c:133:8: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:171:23: note: 'bvprv.bv_offset' was declared here
>>> block/blk-merge.c: In function 'blk_bio_map_sg':
>>> block/blk-merge.c:133:8: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:233:23: note: 'bvprv.bv_len' was declared here
>>> block/blk-merge.c:133:8: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:233:23: note: 'bvprv.bv_offset' was declared here
>>> block/blk-merge.c:133:8: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:233:23: note: 'bvprv.bv_page' was declared here
>>> block/blk-merge.c: In function 'attempt_merge':
>>> block/blk-merge.c:108:7: warning: 'end_bv.bv_offset' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:89:17: note: 'end_bv.bv_offset' was declared here
>>> block/blk-merge.c:108:7: warning: 'end_bv.bv_page' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:89:17: note: 'end_bv.bv_page' was declared here
>>> block/blk-merge.c:108:7: warning: 'end_bv.bv_len' may be used uninitialized in this function [-Wuninitialized]
>>> block/blk-merge.c:89:17: note: 'end_bv.bv_len' was declared here
>>>
>>> arm has its own definition of BIOVEC_PHYS_MERGEABLE() if that is relevant.
>>
>> For an easier test case, the i386 defcongig does this as well.
> 
> I just noticed that i see this with gcc 4.7.0, but 4.8.1 does not warn.

That's good, because it's not a bug. But arguably we should shut up 4.7
as well, however...

-- 
Jens Axboe

