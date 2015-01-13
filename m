Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbbAMXRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:17:22 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbbAMXRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:17:21 -0500
Message-ID: <54B5A77C.9040405@nod.at>
Date: Wed, 14 Jan 2015 00:17:16 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
CC: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tom.leiming@gmail.com
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at> <20150113162553.GA24351@infradead.org> <54B5A188.2000001@nod.at> <54B5A213.1090502@fb.com>
In-Reply-To: <54B5A213.1090502@fb.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.01.2015 um 23:54 schrieb Jens Axboe:
>>> blk_rq_map_sg returns the number of entries actually mapped, which
>>> might be smaller than the number passed in due to merging.
>>
>> Yep, but the ubi_sql has a fixed number of scatterlist entries, UBI_MAX_SG_COUNT.
>> And I limit it also to that using: blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);
>>
>> Is there another reason why I should use the return value of blk_rq_map_sg()?
>> Please also note that the UBI block driver is read-only.
> 
> It can return less than what you asked for, if segments are coalesced.
> Read/write, doesn't matter. You should always use the returned value as
> the indication of how many segments to access in pdu->usgl.sg for data
> transfer.

Sorry, I don't fully understand.

Currently the driver does:
to_read = blk_rq_bytes(req);
Then it fills pdu->usgl.sg up to to_read bytes
and calls blk_mq_end_request().

If I understand you correctly it can happen that blk_rq_bytes() returns
more bytes than blk_rq_map_sg() allocated, right?

Thanks,
//richard
