Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaFDOPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:15:51 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64037 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaFDOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:15:50 -0400
Message-ID: <538F2A11.4060800@kernel.dk>
Date: Wed, 04 Jun 2014 08:15:45 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org> <5388912F.7010609@kernel.dk> <20140604111133.GA7826@infradead.org>
In-Reply-To: <20140604111133.GA7826@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 05:11, Christoph Hellwig wrote:
> On Fri, May 30, 2014 at 08:09:51AM -0600, Jens Axboe wrote:
>> I have applied this one, but it irks me a little bit since we have
>> to touch q->flush_rq->stuff from a potential hot path. I haven't
>> thought much about this yet, but it would be a lot better if we
>> could fold in the flush tag somehow.
>
> This one also breaks scsi-mq by changing the first parameter of
> blk_mq_tag_to_rq.  With host-wide tags we won't have a hardware context
> easily available when looking for a request by tag.

Alright, I'll revert it to pass in the tags instead.

-- 
Jens Axboe

