Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaFDPIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:08:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52793 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaFDPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:08:15 -0400
Message-ID: <538F365C.8050604@kernel.dk>
Date: Wed, 04 Jun 2014 09:08:12 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org> <5388912F.7010609@kernel.dk> <20140604111133.GA7826@infradead.org> <538F2A11.4060800@kernel.dk> <20140604142012.GA20056@infradead.org> <538F331F.60101@kernel.dk> <20140604145803.GA7826@infradead.org> <538F34FB.7050003@kernel.dk> <20140604150508.GA21551@infradead.org>
In-Reply-To: <20140604150508.GA21551@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 09:05, Christoph Hellwig wrote:
> On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
>> OK strange, there hasn't been that much churn since the last rebase.
>> In my for-linus, there's a patch for a single queue crash, but that
>> should just hit for the removal case. And then there's the atomic
>> schedule patch, but that issue was actually in the code base for
>> about a month, so not a new one either.
>
> You're request initializaion optimization doesn't set up req->cmd and
> thus causes all BLOCK_PC I/O (including the SCSI LUN scan) to crash and
> burn.  The trivial fix is on your way.

OK. That'll arguably be a good cleanup as well, getting that initialized 
in the right place. I hate the 'lets clear all the memory' part of rq 
init, it's not super cheap to do.

> The performance regression is caused by "blk-mq: avoid code
> duplication", but I don't really understand why yet.

Gah, looks like this one dropped the tag idling. I bet that is why.


-- 
Jens Axboe

