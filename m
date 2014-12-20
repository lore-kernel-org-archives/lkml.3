Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaLTBng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:43:36 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60369 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLTBnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:43:35 -0500
MIME-Version: 1.0
In-Reply-To: <20141220002303.GD11975@blaptop>
References: <1418993719-14291-1-git-send-email-opensource.ganesh@gmail.com>
	<20141219143244.1e5fabad8b6733204486f5bc@linux-foundation.org>
	<20141219233937.GA11975@blaptop>
	<20141219154548.3aa4cc02b3322f926aa4c1d6@linux-foundation.org>
	<20141219235852.GB11975@blaptop>
	<20141219160648.5cea8a6b0c764caa6100a585@linux-foundation.org>
	<20141220001043.GC11975@blaptop>
	<20141219161756.bcf7421acb4bc7a286c1afa3@linux-foundation.org>
	<20141220002303.GD11975@blaptop>
Date: Sat, 20 Dec 2014 09:43:34 +0800
Message-ID: <CADAEsF-=RwwR2D_LzhVYKhfmfPCsQE73bJYyH=tjn4BtHVrdew@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zsmalloc: add statistics support
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-20 8:23 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> On Fri, Dec 19, 2014 at 04:17:56PM -0800, Andrew Morton wrote:
>> On Sat, 20 Dec 2014 09:10:43 +0900 Minchan Kim <minchan@kernel.org> wrote:
>>
>> > > It involves rehashing a lengthy argument with Greg.
>> >
>> > Okay. Then, Ganesh,
>> > please add warn message about duplicaed name possibility althoug
>> > it's unlikely as it is.
>>
>> Oh, getting EEXIST is easy with this patch.  Just create and destroy a
>> pool 2^32 times and the counter wraps ;) It's hardly a serious issue
>> for a debugging patch.
>
> I meant that I wanted to change from index to name passed from caller like this
>
> zram:
>         zs_create_pool(GFP_NOIO | __GFP_HIGHMEM, zram->disk->first_minor);
>
> So, duplication should be rare. :)

We still can not know whether the name is duplicated if we do not
change the debugfs API.
The API does not return the errno to us.

How about just zsmalloc decides the name of the pool-id, like pool-x.
When the pool-id reaches
0xffff.ffff, we print warn message about duplicated name, and stop
creating the debugfs entry
for the user.

Thanks.
