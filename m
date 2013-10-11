Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab3JKO36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:29:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3JKO34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:29:56 -0400
Message-ID: <52580B26.2090508@kernel.dk>
Date: Fri, 11 Oct 2013 08:28:54 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
CC: kmo@daterainc.com
Subject: Re: [patch 4/4] blk-mq: switch to percpu-ida for tag menagement
References: <20131011071802.148101321@kernel.org> <20131011072404.749268620@kernel.org>
In-Reply-To: <20131011072404.749268620@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 01:18 AM, Shaohua Li wrote:
> Using percpu-ida to manage blk-mq tags. the percpu-ida has similar algorithm
> like the blk-mq-tag. The difference is when a cpu can't allocate tags
> blk-mq-tag uses ipi to purge remote cpu cache and percpu-ida directly purges
> remote cpu cache. In practice (testing null_blk), the percpu-ida approach is
> much faster when total tags aren't enough.

I'm not surprised it's a lot faster the the pathological case of needing
to prune tags, the IPI isn't near ideal for that. I'm assuming the
general performance is the same for the non-full case?

-- 
Jens Axboe

