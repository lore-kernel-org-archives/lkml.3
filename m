Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab3BOPlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:41:42 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:47757 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3BOPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:41:39 -0500
Date: Fri, 15 Feb 2013 16:41:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, devel@openvz.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sched: add wait_for_completion_io[_timeout]
Message-ID: <20130215154135.GB3324@gmail.com>
References: <d5e5c32b045e448072b3a4b77cd6557408b77103.1360851174.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5e5c32b045e448072b3a4b77cd6557408b77103.1360851174.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vladimir Davydov <vdavydov@parallels.com> wrote:

> The only difference between wait_for_completion[_timeout]() and
> wait_for_completion_io[_timeout]() is that the latter calls
> io_schedule_timeout() instead of schedule_timeout() so that the caller
> is accounted as waiting for IO, not just sleeping.
> 
> These functions can be used for correct iowait time accounting when the
> completion struct is actually used for waiting for IO (e.g. completion
> of a bio request in the block layer).
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
