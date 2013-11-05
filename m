Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3KEQWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:22:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34039 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3KEQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:22:33 -0500
Message-ID: <52791B33.9060001@kernel.dk>
Date: Tue, 05 Nov 2013 09:22:11 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Joe Thornber <ejt@redhat.com>
Subject: Re: linux-next: build failure after merge of the device-mapper tree
References: <20131105135128.496b8b2f599d11f2d30ad70c@canb.auug.org.au> <20131105032054.GA19421@redhat.com> <20131105143248.551f68c3cd9fe1902860c1ff@canb.auug.org.au> <20131105125456.GA25219@redhat.com>
In-Reply-To: <20131105125456.GA25219@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 05:54 AM, Mike Snitzer wrote:
> On Mon, Nov 04 2013 at 10:32pm -0500,
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Mike,
>>
>> On Mon, 4 Nov 2013 22:20:54 -0500 Mike Snitzer <snitzer@redhat.com> wrote:
>>>
>>> On Mon, Nov 04 2013 at  9:51pm -0500,
>>> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>>> After merging the device-mapper tree, today's linux-next build (x86_64
>>>> allmodconfig) failed like this:
>>>>
>>>> drivers/md/dm-cache-target.c: In function 'bio_writes_complete_block':
>>>> drivers/md/dm-cache-target.c:1020:7: error: 'struct bio' has no member named 'bi_size'
>>>>    (bio->bi_size == (cache->sectors_per_block << SECTOR_SHIFT));
>>>>        ^
>>>>
>>>> Caused by commit 1bd270d800ec ("dm cache: promotion optimisation for
>>>> writes") interacting with commit ed2d2f9a8265 ("block: Abstract out bvec
>>>> iterator") from the block tree.
>>>>
>>>> I applied this fix up patch and can carry it as necessary:
>>>
>>> Yes that is needed, as is this (which begs the question: how should I be
>>
>> I will add that tomorrow.
>>
>>> handling the fact that post-merge changes are needed?  Especially since
>>> Linus will need the changes too):
>>
>> Who ever gets their tree in last has to tell Linus about these extra
>> merge fix ups as part of their pull request.
> 
> OK, that's what I thought, thanks for confirming.

Just a heads up that I plan on sending the block bits shortly, hopefully
merging sooner rather than later. This round is huge, so I'd like to get
it in asap.

-- 
Jens Axboe

