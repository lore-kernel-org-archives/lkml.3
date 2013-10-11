Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3JKJmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:42:03 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51053 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3JKJmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:42:01 -0400
MIME-Version: 1.0
In-Reply-To: <1381483536.2736.4.camel@AMDC1943>
References: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
	<20131007150338.1fdee18b536bb1d9fe41a07b@linux-foundation.org>
	<1381220000.16135.10.camel@AMDC1943>
	<20131008130853.96139b79a0a4d3aaacc79ed2@linux-foundation.org>
	<20131009144045.GA5406@variantweb.net>
	<525602E3.3080501@oracle.com>
	<20131010022627.GA8535@variantweb.net>
	<CAL1ERfOnb7DZXH87cq2ZWhRiDuU9btmmRbOURLA5SV7zsho1VA@mail.gmail.com>
	<1381483536.2736.4.camel@AMDC1943>
Date: Fri, 11 Oct 2013 17:42:00 +0800
Message-ID: <CAL1ERfOzgbodgi5vfWFxzUu88UWoS8PFiJGUrHnvcn_=s-fLAQ@mail.gmail.com>
Subject: Re: [PATCH] frontswap: enable call to invalidate area on swapoff
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>, Bob Liu <bob.liu@oracle.com>,
        Seth Jennings <spartacus06@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 5:25 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On Fri, 2013-10-11 at 10:23 +0800, Weijie Yang wrote:
>> I am sorry to interrupt this topic, but I found an tiny issue near that:
>>
>> we can not "set_blocksize(bdev, p->old_block_size);" at the end of swapoff()
>> because swap_info p may be reused by concurrent swapon called
>> I think we need to  save the p->old_block_size in a local var and use it instead
> I confirm the race here (I was able to trigger it on the same swap type).
>
>
>> to Krzysztof : would you please add this in your patch?
>> Thanks
> I think it should be another patch as this is not related with
> frontswap. I'll send new one and add you as Reported-by. Is it OK with
> you?

All right.

>
> Best regards,
> Krzysztof
>
