Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaJ1R0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:26:43 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63449 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaJ1R0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:26:41 -0400
Message-ID: <544FD1CF.5000505@kernel.dk>
Date: Tue, 28 Oct 2014 11:26:39 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] block: wrong return value
References: <1414082808-7484-1-git-send-email-sudipm.mukherjee@gmail.com> <20141028172234.GA12775@sudip-PC>
In-Reply-To: <20141028172234.GA12775@sudip-PC>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-28 11:22, Sudip Mukherjee wrote:
> On Thu, Oct 23, 2014 at 10:16:48PM +0530, Sudip Mukherjee wrote:
>> while compiling integer err was showing as a set but unused variable.
>> elevator_init_fn can be either cfq_init_queue or deadline_init_queue
>> or noop_init_queue.
>> all three of these functions are returning -ENOMEM if they fail to
>> allocate the queue.
>> so we should actually be returning the error code rather than
>> returning 0 always.
> i have one doubt. shouldn't this patch be marked for stable also?

It would not hurt to mark it as stable, but on the other hand, this 
probably never triggered a problem for anyone. So it's not a critical 
fix by any stretch.

-- 
Jens Axboe

