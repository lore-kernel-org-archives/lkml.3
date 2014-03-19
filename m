Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396AbaCSO0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:26:21 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36314 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbaCSOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:25:41 -0400
Message-ID: <5329A8E1.7090201@converseincode.com>
Date: Wed, 19 Mar 2014 07:25:37 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        =?UTF-8?B?SmFuLVNpbW9uIE3Dtmxs?= =?UTF-8?B?ZXI=?= <dl9pf@gmx.de>,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v3] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
References: <CABikg9x+Z95bHcDc6iu5hBvRNO-ibM8-34_qA+OA_FjB52SPMw@mail.gmail.com>	 <1395199933-4686-1-git-send-email-behanw@converseincode.com>	 (sfid-20140319_043225_892297_337F53BC) <1395237113.4142.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1395237113.4142.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/14 06:51, Johannes Berg wrote:
> I'm confused.
>
> On Tue, 2014-03-18 at 20:32 -0700, behanw@converseincode.com wrote:
>
>
>>   	struct scatterlist assoc, pt, ct[2];
>> -	struct {
>> -		struct aead_request	req;
>> -		u8			priv[crypto_aead_reqsize(tfm)];
>> -	} aead_req;
>>   
>> -	memset(&aead_req, 0, sizeof(aead_req));
>> +	char aead_req_data[sizeof(struct aead_request) +
>> +		crypto_aead_reqsize(tfm)]
>> +		__aligned(__alignof__(struct aead_request));
> This looks fine, though I'd argue the blank lines before/after it
> shouldn't be there, and the indentation should be a bit different, but I
> was willing to clean that up.
Will fix.

>>   int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
>>   			      u8 *data, size_t data_len, u8 *mic)
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
> But why does the second instance use a completely different size/align?
Because I neglected to update it in both places. Sorry. Will fix.

Behan

-- 
Behan Webster
behanw@converseincode.com

