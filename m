Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaCEXKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:10:14 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47348 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaCEXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:10:12 -0500
Message-ID: <5317AED1.4050104@kernel.dk>
Date: Wed, 05 Mar 2014 16:10:09 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Roman Pen <r.peniaev@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] blktrace: fix accounting of partially completed requests
References: <1393942390-21293-1-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1393942390-21293-1-git-send-email-r.peniaev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 07:13 AM, Roman Pen wrote:
> trace_block_rq_complete does not take into account that request can
> be partially completed, so we can get the following incorrect output
> of blkparser:
>
>    C   R 232 + 240 [0]
>    C   R 240 + 232 [0]
>    C   R 248 + 224 [0]
>    C   R 256 + 216 [0]
>
> but should be:
>
>    C   R 232 + 8 [0]
>    C   R 240 + 8 [0]
>    C   R 248 + 8 [0]
>    C   R 256 + 8 [0]
>
> Also, the whole output summary statistics of completed requests and
> final throughput will be incorrect.
>
> This patch takes into account real completion size of the request and
> fixes wrong completion accounting.

Thanks Roman, this looks good. I'll apply it for 3.15, but with an added 
stable tag as well.

-- 
Jens Axboe

