Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaKGMVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:21:09 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35609 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaKGMVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:21:05 -0500
Message-ID: <545CB92E.9050106@linaro.org>
Date: Fri, 07 Nov 2014 12:21:02 +0000
From: Zoltan Kiss <zoltan.kiss@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] BUG in xennet_make_frags with paged skb data
References: <20141106214940.GD44162@ubuntu-hedt>	 <545C9013.1090406@linaro.org> <1415359320.13896.105.camel@edumazet-glaptop2.roam.corp.google.com> <545CB7FF.8080003@canonical.com>
In-Reply-To: <545CB7FF.8080003@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/11/14 12:15, Stefan Bader wrote:
> On 07.11.2014 12:22, Eric Dumazet wrote:
>> On Fri, 2014-11-07 at 09:25 +0000, Zoltan Kiss wrote:
>>
>> Please do not top post.
>>
>>> Hi,
>>>
>>> AFAIK in this scenario your skb frag is wrong. The page pointer should
>>> point to the original compound page (not a member of it), and offset
>>> should be set accordingly.
>>> For example, if your compound page is 16K (4 page), then the page
>>> pointer should point to the first page, and if the data starts at the
>>> 3rd page, then offset should be >8K
>>
>> This is not accurate.
>>
>> This BUG_ON() is wrong.
>>
>> It should instead be :
>>
>> BUG_ON(len + offset > PAGE_SIZE<<compound_order(compound_head(page)));
>
> would that not have to be
>
> BUG_ON((page-compound_head(page)*PAGE_SIZE)+offset+len >
> PAGE_SIZE<<compound_order(compound_head(page)));

There should be a parentheses around "page-compound_head(page)".
>
> since offset is adjusted to start from the tail page in that case.
>>
>> splice() code can generate such cases.
>>
>>
>
>
