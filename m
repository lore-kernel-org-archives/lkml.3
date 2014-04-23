Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaDWVqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:46:15 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48960 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaDWVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:46:12 -0400
Message-ID: <5358349F.7090003@gmail.com>
Date: Wed, 23 Apr 2014 23:46:07 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] [media] V4L: s5c73m3: Fix build after v4l2_of_get_next_endpoint
 rename
References: <1397044446-2257-1-git-send-email-k.kozlowski@samsung.com> <alpine.DEB.2.02.1404231354370.1281@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1404231354370.1281@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 10:57 PM, David Rientjes wrote:
> On Wed, 9 Apr 2014, Krzysztof Kozlowski wrote:
>
>> Fix build error after v4l2_of_get_next_endpoint rename (fd9fdb78a9bf:
>> "[media] of: move graph helpers from drivers/media/v4l2-core..."):
>>
>> drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘s5c73m3_get_platform_data’:
>> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:2: error: implicit declaration of function ‘v4l2_of_get_next_endpoint’ [-Werror=implicit-function-declaration]
>> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:10: warning: assignment makes pointer from integer without a cast [enabled by default]
>>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>   drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
>> index a4459301b5f8..ee0f57e01b56 100644
>> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
>> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
>> @@ -1616,7 +1616,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
>>   	if (ret < 0)
>>   		return -EINVAL;
>>
>> -	node_ep = v4l2_of_get_next_endpoint(node, NULL);
>> +	node_ep = of_graph_get_next_endpoint(node, NULL);
>>   	if (!node_ep) {
>>   		dev_warn(dev, "no endpoint defined for node: %s\n",
>>   						node->full_name);
>
> Acked-by: David Rientjes <rientjes@google.com>
>
> The build error that this patch fixes is still present in Linus's tree,
> and there's been no response to it in two weeks.  Any chance of this
> getting merged?

I expect a patch fixing this issue to be sent in next batch of the media
fixes from Mauro.  It has been queued in the media tree:

http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?h=fixes&id=41f484d12c0105ce01ea79acdc094fff9124491b

Thanks,
Sylwester

