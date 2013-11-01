Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3KAQeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:34:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3KAQee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:34:34 -0400
Message-ID: <5273D80F.5070205@kernel.dk>
Date: Fri, 01 Nov 2013 10:34:23 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        linux-kernel@vger.kernel.org
Subject: Re: stec skd block driver needs updating for immutable biovec
References: <20131101135931.GA22903@redhat.com> <5273C2B8.5030608@kernel.dk> <20131101154338.GA23501@redhat.com> <20131101155027.GA5665@infradead.org> <5273D0B1.2030006@kernel.dk> <20131101162823.GB23501@redhat.com>
In-Reply-To: <20131101162823.GB23501@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 10:28 AM, Mike Snitzer wrote:
> On Fri, Nov 01 2013 at 12:02pm -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 11/01/2013 09:50 AM, Christoph Hellwig wrote:
>>> On Fri, Nov 01, 2013 at 11:43:39AM -0400, Mike Snitzer wrote:
>>>> All the bi_sector ones are low hanging fruit, but the conversion for
>>>> skd_preop_sg_list_bio()'s bio_vec code is more involved.
>>>>
>>>> Kent, any chance you could crank through it?
>>>>
>>>> If not I can come back to trying to fix this later.. but I'm working
>>>> through a test merge of linux-dm.git's 'for-next' with linux-block.git's
>>>> 'for-next'.
>>>
>>> The right thing for 3.13 is to rip out the bio base code path, and
>>> for 3.14 to convert it to blk-mq.
>>
>> It is. I will kill it.
> 
> I just cranked through it.. hope this helps (think I got everything but
> may have missed something):

You lost out, I committed it 20 min ago :-0

http://git.kernel.dk/?p=linux-block.git;a=commit;h=1d36f7a5fb577afaaead6c5e2fc8e01e0c95235d

Looks like you missed some of the skd_device removal, while I neglected
killing bio/start_time in the skd_request_context.

-- 
Jens Axboe

