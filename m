Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3JKJZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:25:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51027 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3JKJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:25:39 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-ba-5257c411c137
Message-id: <1381483536.2736.4.camel@AMDC1943>
Subject: Re: [PATCH] frontswap: enable call to invalidate area on swapoff
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>, Bob Liu <bob.liu@oracle.com>,
        Seth Jennings <spartacus06@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>
Date: Fri, 11 Oct 2013 11:25:36 +0200
In-reply-to: <CAL1ERfOnb7DZXH87cq2ZWhRiDuU9btmmRbOURLA5SV7zsho1VA@mail.gmail.com>
References: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
 <20131007150338.1fdee18b536bb1d9fe41a07b@linux-foundation.org>
 <1381220000.16135.10.camel@AMDC1943>
 <20131008130853.96139b79a0a4d3aaacc79ed2@linux-foundation.org>
 <20131009144045.GA5406@variantweb.net> <525602E3.3080501@oracle.com>
 <20131010022627.GA8535@variantweb.net>
 <CAL1ERfOnb7DZXH87cq2ZWhRiDuU9btmmRbOURLA5SV7zsho1VA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xa7qCR8KDDCZPMbWYs34Nm0XXqaks
	FssWP2W0uLxrDpvFvTX/WS2WfX3PbnFqOYfFp6OP2CzOLtrAbPHkxH8WBy6PJ00/mT12zrrL
	7rFpVSebx6ZPk9g9Tsz4zeLx8ektFo/r34o8Pm+SC+CI4rJJSc3JLEst0rdL4MroX3+ZuWAd
	a0Xj5uAGxmksXYycHBICJhKtbV/ZIWwxiQv31rN1MXJxCAksZZT40v4IyvnMKHHo0U+wKl4B
	PYlNr38zgdjCAp4SkxZ/ZwOx2QSMJTYvXwJkc3CICGhJdH3nAwkzC5xgkvh00wYkzCKgKrG7
	JwjE5BQIlnj52RRi+nJmienzdrNBlKtLTJq3iBniHiWJ3e2d7BBxeYnNa94yQ1wgKPFj8j2W
	CYwCs5C0zEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIZHxdQfj0mNWhxgF
	OBiVeHhnhoQHCbEmlhVX5h5ilOBgVhLh3TcfKMSbklhZlVqUH19UmpNafIiRiYNTqoHxcnFO
	HBP/tBmmq9/cSpEoOFWilZO1eIt9bUGuDsvfy73Pko7MUO1avHjypSM8DRP37vkbbh32x8Dv
	vdVfvqaOZQu22s3js3ScrJTTItX54b6ugXb9+e6wfJfuvQ3bw5XmP8rYWdN5tEd+93KRqsVl
	j8qrLy7e7vmCk21H3OOytQLz/Axmd/UrsRRnJBpqMRcVJwIASrs8uWoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 10:23 +0800, Weijie Yang wrote:
> I am sorry to interrupt this topic, but I found an tiny issue near that:
> 
> we can not "set_blocksize(bdev, p->old_block_size);" at the end of swapoff()
> because swap_info p may be reused by concurrent swapon called
> I think we need to  save the p->old_block_size in a local var and use it instead
I confirm the race here (I was able to trigger it on the same swap type).


> to Krzysztof : would you please add this in your patch?
> Thanks
I think it should be another patch as this is not related with
frontswap. I'll send new one and add you as Reported-by. Is it OK with
you?


Best regards,
Krzysztof

