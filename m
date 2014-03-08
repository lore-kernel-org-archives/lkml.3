Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaCHCPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:15:49 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39119 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaCHCPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:15:47 -0500
Message-ID: <531A7D4F.7090303@converseincode.com>
Date: Fri, 07 Mar 2014 18:15:43 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        =?ISO-8859-1?Q?Jan-Simon_M=F6?= =?ISO-8859-1?Q?ller?= 
	<dl9pf@gmx.de>,
        =?ISO-8859-1?Q?Vin=EDcius_Tinti?= <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
References: <1394177091.4653.1.camel@jlt4.sipsolutions.net>	 <1394241960-1764-1-git-send-email-behanw@converseincode.com> <1394243809.6972.4.camel@joe-AO722>
In-Reply-To: <1394243809.6972.4.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 17:56, Joe Perches wrote:
> On Fri, 2014-03-07 at 17:26 -0800, behanw@converseincode.com wrote:
>> From: Jan-Simon Möller <dl9pf@gmx.de>
>>
>> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
>> compliant equivalent. This is the original VLAIS struct.
> []
>> diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
> []
>> @@ -23,12 +23,14 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
>>   			       u8 *data, size_t data_len, u8 *mic)
>>   {
>>   	struct scatterlist assoc, pt, ct[2];
>> -	struct {
>> -		struct aead_request	req;
>> -		u8			priv[crypto_aead_reqsize(tfm)];
>> -	} aead_req;
>>   
>> -	memset(&aead_req, 0, sizeof(aead_req));
>> +	char aead_req_data[sizeof(struct aead_request) +
>> +				crypto_aead_reqsize(tfm) +
>> +				CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
> Can this be a too large amount of stack?
>
> Is crypto_aead_reqsize() limited to < ~1k?
>
> Perhaps it'd be better to use kzalloc for this
> or another reserved pool
No more stack being used than with the the original code. The stack 
memory use is identical.

Behan

-- 
Behan Webster
behanw@converseincode.com

