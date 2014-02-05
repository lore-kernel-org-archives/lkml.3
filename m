Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaBEUh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:37:58 -0500
Received: from mail1.windriver.com ([147.11.146.13]:49294 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaBEUhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:37:55 -0500
Message-ID: <52F2A140.5060602@windriver.com>
Date: Wed, 5 Feb 2014 15:38:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2.6.34-stable 004/213] crypto: ghash - Avoid null pointer dereference
 if no key is set
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com> <1391630568-49251-5-git-send-email-paul.gortmaker@windriver.com> <20140205203027.GA23845@elliptictech.com>
In-Reply-To: <20140205203027.GA23845@elliptictech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-02-05 03:30 PM, Nick Bowler wrote:
> On 2014-02-05 14:59 -0500, Paul Gortmaker wrote:
>> From: Nick Bowler <nbowler@elliptictech.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit 7ed47b7d142ec99ad6880bbbec51e9f12b3af74c upstream.
>>
>> The ghash_update function passes a pointer to gf128mul_4k_lle which will
>> be NULL if ghash_setkey is not called or if the most recent call to
>> ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
>> up by returning an error code in the null case.
>>
>> This is trivially triggered from unprivileged userspace through the
>> AF_ALG interface by simply writing to the socket without setting a key.
> 
> After all this time, I see this patch still manages to find its way,
> occasionally, into the patch queue for older -stable. :)
> 
> It should be harmless to apply, but this patch doesn't actually fix
> any real problem on kernels previous to 2.6.38 because the AF_ALG
> userspace interface does not exist in these kernels.

Thanks, I'll drop it then, since less churn in a stable release is
desired, where possible.  I saw it tagged 2.6.37+, but then I also
saw it applied in 2.6.32.x, so I wasn't sure what to make of it.

Paul.
--

> 
> Cheers,
> 
