Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaLEIov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:44:51 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:45763 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579AbaLEIot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:44:49 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44553942"
Message-ID: <54816CD3.90107@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 16:29:07 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] net: introduce helper macra CMSG_FOREACH_HDR
References: <54815B40.1050909@cn.fujitsu.com> <1417766552.2721.45.camel@perches.com>
In-Reply-To: <1417766552.2721.45.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,
Thanks for your comment.
On 12/05/2014 04:02 PM, Joe Perches wrote:

> On Fri, 2014-12-05 at 15:14 +0800, Gu Zheng wrote:
>> Introduce helper macra
> 
> macro

Ah~, it's a typo.

> 
>> CMSG_FOREACH_HDR as a wrapper of the enumerating
>> cmsghdr from msghdr, just cleanup. 
> 
> maybe better to use lower case "for_each_cmsg_hdr"
> or some such.

But this will make it out of the ordinary, as the existed ones
are all upper.

David, what's your opinion?

Regards,
Gu

> 
> checkpatch would recognize that too as long as it
> uses "for_each".
> 
>> diff --git a/include/linux/socket.h b/include/linux/socket.h
> []
>> @@ -94,6 +94,10 @@ struct cmsghdr {
>>  			     (cmsg)->cmsg_len <= (unsigned long) \
>>  			     ((mhdr)->msg_controllen - \
>>  			      ((char *)(cmsg) - (char *)(mhdr)->msg_control)))
>> +#define CMSG_FOREACH_HDR(cmsg, msg)  \
>> +	for (cmsg = CMSG_FIRSTHDR(msg); \
>> +	     cmsg; \
>> +	     cmsg = CMSG_NXTHDR(msg, cmsg))
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


