Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaGIOvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:51:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:22059 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbaGIOvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:51:37 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="150985425"
Message-ID: <53BD56F6.3060407@citrix.com>
Date: Wed, 9 Jul 2014 15:51:34 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <steffen.klassert@secunet.com>, <minipli@googlemail.com>,
        <dborkman@redhat.com>, <tgraf@suug.ch>, <joe@perches.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next 1/3 v4] pktgen: Fill the payload optionally with
 a pattern
References: <1404330855-24546-1-git-send-email-zoltan.kiss@citrix.com>	<1404330855-24546-2-git-send-email-zoltan.kiss@citrix.com> <20140708.112838.2087453949565741801.davem@davemloft.net>
In-Reply-To: <20140708.112838.2087453949565741801.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:28, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Wed, 2 Jul 2014 20:54:13 +0100
>
>> @@ -1129,11 +1133,13 @@ static ssize_t pktgen_if_write(struct file *file,
>>   		i += len;
>>
>>   		if (node_possible(value)) {
>> +			int j;
>>   			pkt_dev->node = value;
>>   			sprintf(pg_result, "OK: node=%d", pkt_dev->node);
>> -			if (pkt_dev->page) {
>> -				put_page(pkt_dev->page);
>> -				pkt_dev->page = NULL;
>> +			for (j = 0; j < MAX_SKB_FRAGS; ++j)
>> +				if (pkt_dev->pages[j]) {
>> +					put_page(pkt_dev->pages[j]);
>> +					pkt_dev->pages[j] = NULL;
>>   			}
>>   		}
>
> I'm scratching my head with the bracing created here, and it's because
> the indentation is wrong:
>
> 	for () /* <-- no openning curly brace */
> 		if () {
> 			x;
> 			y;
> 	} /* <-- thus, wrong indentation */

Hm, checkpatch couldn't catch this, I'll report it to the maintainers.

Zoli

