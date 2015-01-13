Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbbAMXgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:36:53 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbbAMXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:36:52 -0500
Message-ID: <54B5AC10.6070102@nod.at>
Date: Wed, 14 Jan 2015 00:36:48 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
CC: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tom.leiming@gmail.com
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at> <20150113162553.GA24351@infradead.org> <54B5A188.2000001@nod.at> <54B5A213.1090502@fb.com> <54B5A77C.9040405@nod.at> <54B5AA84.9010306@fb.com>
In-Reply-To: <54B5AA84.9010306@fb.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 14.01.2015 um 00:30 schrieb Jens Axboe:
>> If I understand you correctly it can happen that blk_rq_bytes() returns
>> more bytes than blk_rq_map_sg() allocated, right?
> 
> No, the number of bytes will be the same, no magic is involved :-)

Good to know. :)

> But lets say the initial request has 4 bios, with each 2 pages, for a
> total of 8 segments. Lets further assume that the pages in each bio are
> contiguous, so that blk_rq_map_sg() will map this to 4 sg elements, each
> 2xpages long.
> 
> Now, this may already be handled just fine, and you don't need to
> update/store the actual sg count. I just looked at the source, and I'm
> assuming it'll do the right thing (ubi_read_sg() will bump the active sg
> element, when that size has been consumed), but I don't have
> ubi_read_sg() in my tree to verify.

Currently the sg count is hard coded to UBI_MAX_SG_COUNT.

I'm sorry, I forgot to CC you and hch to this patch:
https://lkml.org/lkml/2015/1/10/204

Thanks,
//richard

