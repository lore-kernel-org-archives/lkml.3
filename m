Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3J2VZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:25:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3J2VZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:25:11 -0400
Message-ID: <527027B1.8070808@kernel.dk>
Date: Tue, 29 Oct 2013 15:25:05 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] kernel: use lockless list for smp_call_function_single
References: <20131024151921.537751910@bombadil.infradead.org> <20131024152314.204817634@bombadil.infradead.org> <20131029192536.GB9568@quack.suse.cz> <20131029192720.GA24089@infradead.org> <20131029211715.GA12814@quack.suse.cz>
In-Reply-To: <20131029211715.GA12814@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 03:17 PM, Jan Kara wrote:
> On Tue 29-10-13 12:27:20, Christoph Hellwig wrote:
>> On Tue, Oct 29, 2013 at 08:25:36PM +0100, Jan Kara wrote:
>>>   I'm wondering: Who's still using the normal list_head? I was grepping for
>>> a while and I couldn't find any user. Otherwise the patch looks good to me.
>>
>> The block/blk-softirq.c code is abusing it in a fairly ugly way.
>   Ah, thanks for the pointer. Looking into the code, that could easily use
> llist as well, couldn't it?

Sure, it'd be easy enough to do.

-- 
Jens Axboe

