Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3C1QI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:08:29 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:56067 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3C1QI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130328143216.GC23043@casper.infradead.org>
References: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
	<20130328143216.GC23043@casper.infradead.org>
Date: Fri, 29 Mar 2013 00:08:26 +0800
Message-ID: <CAA7+ByVp4K__=mESAu4jEy=t4TJD+rV0KOA2ZhHSinm1fvedzg@mail.gmail.com>
Subject: Re: [PATCH 1/6] net-next: replace obsolete NLMSG_* with type safe nlmsg_*
From: Hong zhi guo <honkiko@gmail.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, stephen@networkplumber.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Thomas. But I didn't change any formatting. Just do the
substitution in place.
Should I re-format and re-send the patch?

On Thu, Mar 28, 2013 at 10:32 PM, Thomas Graf <tgraf@suug.ch> wrote:
> On 03/28/13 at 12:47am, Hong Zhiguo wrote:
>> diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
>> index 505b30a..467fb92 100644
>> --- a/net/ipv4/udp_diag.c
>> +++ b/net/ipv4/udp_diag.c
>> @@ -64,9 +64,9 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
>>               goto out;
>>
>>       err = -ENOMEM;
>> -     rep = alloc_skb(NLMSG_SPACE((sizeof(struct inet_diag_msg) +
>> -                                  sizeof(struct inet_diag_meminfo) +
>> -                                  64)), GFP_KERNEL);
>> +     rep = nlmsg_new(sizeof(struct inet_diag_msg) +
>> +                                  sizeof(struct inet_diag_meminfo) + 64,
>> +                                  GFP_KERNEL);
>
> This is formatted incorrectly, otherwise the patch looks good.



--
best regards
Hong Zhiguo
