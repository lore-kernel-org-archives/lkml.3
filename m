Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3HIRIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:08:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43245 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab3HIRIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:08:42 -0400
Message-ID: <520521D9.3040104@kernel.dk>
Date: Fri, 09 Aug 2013 11:07:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
References: <1374527436.7397.1145.camel@haakon3.risingtidesystems.com> <20130725101641.GB31994@dhcp-26-207.brq.redhat.com> <1374790082.7397.1411.camel@haakon3.risingtidesystems.com> <20130726020928.GL29296@kernel.dk> <1374873276.7397.1512.camel@haakon3.risingtidesystems.com> <20130729114653.GB20951@mtj.dyndns.org> <20130809082335.GA25306@dhcp-26-207.brq.redhat.com> <5204FBA6.6040001@kernel.dk> <20130809150744.GB25306@dhcp-26-207.brq.redhat.com> <52051033.8050605@kernel.dk> <20130809164632.GC25306@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20130809164632.GC25306@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 10:46 AM, Alexander Gordeev wrote:
> On Fri, Aug 09, 2013 at 09:52:19AM -0600, Jens Axboe wrote:
>> On 08/09/2013 09:07 AM, Alexander Gordeev wrote:
>>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>>> index dcbc2a4..b131a48 100644
>>> --- a/block/blk-mq-tag.c
>>> +++ b/block/blk-mq-tag.c
>>> @@ -468,10 +468,9 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
>>>  	 * Rest of the tags start at the queue list
>>>  	 */
>>>  	tags->nr_free = 0;
>>> -	while (nr_tags - tags->nr_reserved) {
>>> +	while (nr_tags--) {
>>>  		tags->freelist[tags->nr_free] = tags->nr_free +
>>>  							tags->nr_reserved;
>>> -		nr_tags--;
>>>  		tags->nr_free++;
>>>  	}
>>
>> I misremembered, just checked the code. I think I used to have it like I
>> described, but changed it since I thought it would be more logical to
>> pass in full depth, and then what part of that is reserved. Looking at
>> the current code, your patch looks correct as-is.
> 
> Ok, then a whole series "[PATCH 0/3] blk-mq: Avoid effects of a weird queue
> depth" (I posted earlier in a separate thread) should make sense. Besides
> the hunk above it limits the per-cpu cache size and sanity-checks total vs
> reserved length. I can resubmit if you want.

You don't have to resubmit, I'll get it reviewed and applied today.

-- 
Jens Axboe

