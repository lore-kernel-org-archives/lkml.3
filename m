Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaKWRsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:48:42 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:37921 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaKWRsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:48:41 -0500
Date: Sun, 23 Nov 2014 12:48:38 -0500
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH percpu/for-3.18-fixes] percpu-ref: fix DEAD flag
 contamination of percpu pointer
Message-ID: <20141123174838.GB22488@htj.dyndns.org>
References: <995deb699f5b873c45d667df4add3b06f73c2c25.1416638887.git.shli@kernel.org>
 <20141122142242.GB26007@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141122142242.GB26007@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 09:22:42AM -0500, Tejun Heo wrote:
> While decoupling ATOMIC and DEAD flags, f47ad4578461 ("percpu_ref:
> decouple switching to percpu mode and reinit") updated
> __ref_is_percpu() so that it only tests ATOMIC flag to determine
> whether the ref is in percpu mode or not; however, while DEAD implies
> ATOMIC, the two flags are set separately during percpu_ref_kill() and
> if __ref_is_percpu() races percpu_ref_kill(), it may see DEAD w/o
> ATOMIC.  Because __ref_is_percpu() returns @ref->percpu_count_ptr
> value verbatim as the percpu pointer after testing ATOMIC, the pointer
> may now be contaminated with the DEAD flag.
> 
> This can be fixed by clearing the flag bits before returning the
> pointer which was the fix proposed by Shaohua; however, as DEAD
> implies ATOMIC, we can just test for both flags at once and avoid the
> explicit masking.
> 
> Update __ref_is_percpu() so that it tests that both ATOMIC and DEAD
> are clear before returning @ref->percpu_count_ptr as the percpu
> pointer.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Shaohua Li <shli@kernel.org>
> Link: http://lkml.kernel.org/r/995deb699f5b873c45d667df4add3b06f73c2c25.1416638887.git.shli@kernel.org
> Fixes: f47ad4578461 ("percpu_ref: decouple switching to percpu mode and reinit")

Applied to percpu/for-3.18-fixes and pushed out to Linus.

Thanks.

-- 
tejun
