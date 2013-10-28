Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab3J1TjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:39:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3J1TjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:39:14 -0400
Message-ID: <526EBD5D.3080502@kernel.dk>
Date: Mon, 28 Oct 2013 13:39:09 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org
Subject: Re: blk-mq flush fix
References: <20131026114612.GA8576@infradead.org> <20131026153124.GA22227@infradead.org> <20131027222914.GG22549@kernel.dk> <20131028084821.GA31270@infradead.org> <526E90D7.1070604@kernel.dk> <20131028164641.GA1046@infradead.org> <526E97F4.3050104@kernel.dk> <20131028193024.GA21108@infradead.org>
In-Reply-To: <20131028193024.GA21108@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 01:30 PM, Christoph Hellwig wrote:
> On Mon, Oct 28, 2013 at 10:59:32AM -0600, Jens Axboe wrote:
>>> The problem with it is that it will pass a tag number to the low level
>>> driver which it doesn't expect.  In case the tags are used 1:1 as
>>> hardware tags that would lead to nasy bugs.
>>>
>>> At vefy least we'd need to mess with ->tag for this special request.
>>
>> Yes indeed. Actually the more I think about it, the better I like just
>> using the normal tagging infrastructure and punting to a reserved tag
>> for the flush. Just needs adding of the check whether it actually needs
>> it or not.
> 
> That issue happens when using reserved tags as-is: e.g. the device
> supports 32 hardware tag, first reserved one is 33, something the
> hardware can't handle.
> 
> So either way we'll have to copy over the tag from the original request.
> 
> I don't think I can come up with something sane for that ASAP, so I'd
> suggest you actually do take my patch for now, and we'll sort something
> out less in a hurry.

Agree, I will queue it up.

-- 
Jens Axboe

