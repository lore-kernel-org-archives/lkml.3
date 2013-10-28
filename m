Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3J1Q7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:59:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55198 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3J1Q7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:59:36 -0400
Message-ID: <526E97F4.3050104@kernel.dk>
Date: Mon, 28 Oct 2013 10:59:32 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org
Subject: Re: blk-mq flush fix
References: <20131026114612.GA8576@infradead.org> <20131026153124.GA22227@infradead.org> <20131027222914.GG22549@kernel.dk> <20131028084821.GA31270@infradead.org> <526E90D7.1070604@kernel.dk> <20131028164641.GA1046@infradead.org>
In-Reply-To: <20131028164641.GA1046@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 10:46 AM, Christoph Hellwig wrote:
> On Mon, Oct 28, 2013 at 10:29:11AM -0600, Jens Axboe wrote:
>> It's not that I think the existing patch is THAT bad, it fits in alright
>> with the reserved tagging and works regardless of whether a driver uses
>> reserved tags or not. And it does have the upside of not requiring
>> special checks or logic for this special non-tagged request that using
>> the preallocated would might need.
> 
> The problem with it is that it will pass a tag number to the low level
> driver which it doesn't expect.  In case the tags are used 1:1 as
> hardware tags that would lead to nasy bugs.
> 
> At vefy least we'd need to mess with ->tag for this special request.

Yes indeed. Actually the more I think about it, the better I like just
using the normal tagging infrastructure and punting to a reserved tag
for the flush. Just needs adding of the check whether it actually needs
it or not.

-- 
Jens Axboe

