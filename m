Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3KEVZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:25:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39979 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3KEVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:25:21 -0500
Message-ID: <5279622C.8040509@kernel.dk>
Date: Tue, 05 Nov 2013 14:25:00 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Tomasz Figa <t.figa@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>
CC: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Boot failure on Arndale with next-20131105
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com> <1451170.jb5zbRXgpt@amdc1227> <52792D13.70704@wwwdotorg.org>
In-Reply-To: <52792D13.70704@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 10:38 AM, Stephen Warren wrote:
> I note that compiling next-20131105 generates quite a few warnings re:
> uninitialized variables. Reverting the commit doesn't solve those.
> 
>> block/blk-merge.c: In function ‘blk_bio_map_sg’:
>> block/blk-merge.c:133:8: warning: ‘bvprv.bv_len’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:233:23: note: ‘bvprv.bv_len’ was declared here
>> block/blk-merge.c:133:8: warning: ‘bvprv.bv_offset’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:233:23: note: ‘bvprv.bv_offset’ was declared here
>> block/blk-merge.c:133:8: warning: ‘bvprv.bv_page’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:233:23: note: ‘bvprv.bv_page’ was declared here
>> block/blk-merge.c: In function ‘blk_rq_map_sg’:
>> block/blk-merge.c:133:8: warning: ‘bvprv.bv_page’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:171:23: note: ‘bvprv.bv_page’ was declared here
>> block/blk-merge.c:133:8: warning: ‘bvprv.bv_offset’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:171:23: note: ‘bvprv.bv_offset’ was declared here
>> block/blk-merge.c:133:8: warning: ‘bvprv.bv_len’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:171:23: note: ‘bvprv.bv_len’ was declared here
>> block/blk-merge.c: In function ‘attempt_merge’:
>> block/blk-merge.c:108:7: warning: ‘end_bv.bv_offset’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:89:17: note: ‘end_bv.bv_offset’ was declared here
>> block/blk-merge.c:108:7: warning: ‘end_bv.bv_page’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:89:17: note: ‘end_bv.bv_page’ was declared here
>> block/blk-merge.c:108:7: warning: ‘end_bv.bv_len’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> block/blk-merge.c:89:17: note: ‘end_bv.bv_len’ was declared here

Looks like an incomplete merge. The patch to silence those warnings
(which aren't bugs, BTW) is definitely in my for-next branch.

-- 
Jens Axboe

