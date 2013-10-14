Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3JNNgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:36:25 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:64574 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3JNNgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:36:24 -0400
Date: Mon, 14 Oct 2013 09:36:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Hong Zhiguo <honkiko@gmail.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Message-ID: <20131014133620.GF4722@htj.dyndns.org>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 14, 2013 at 05:09:17PM +0800, Hong Zhiguo wrote:
> From: Hong Zhiguo <zhiguohong@tencent.com>
> 
> Token bucket algorithm(http://en.wikipedia.org/wiki/Token_bucket)
> is very simple and widely used for rate limiting and shaping.
> It's well suitable for blk-throttle. And it natually works for
> hierarchical cgroups. So I took it to replace the original time
> _slicing_|_trimming_|_extending_ logic.
> 
> The advantage is simplicity, reliability and less fluctuation.
> 
> About 300 lines of code for time-slicing is replaced with 60 lines of
> code for token bucket in blk-throttle.c.
> 
> I've tested this patch by fio with rw=randread, rw=randrw. It
> behaves almost the same with original time-slicing implementation,
> and with more accuracy.

Yes, this definitely is the direction we wanna take it.  I'll wait for
Vivek to chime in but have you also tested hierarchical setup?

Thanks.

-- 
tejun
