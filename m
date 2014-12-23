Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaLWRQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:16:13 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:31698 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaLWRQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:16:11 -0500
Message-ID: <5499A351.2010300@c-s.fr>
Date: Tue, 23 Dec 2014 18:16:01 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: algif_hash: splice of data > 2**16
References: <8707521.TbV00HIEUx@tauon> <5492C6FC.50005@c-s.fr> <3364866.GGZiChayfE@tachyon.chronox.de>
In-Reply-To: <3364866.GGZiChayfE@tachyon.chronox.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 20/12/2014 07:37, Stephan Mueller a écrit :
> Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe:
>
> Hi Christophe,
>
>> Le 18/12/2014 13:15, Stephan Mueller a écrit :
>>> Hi Herbert,
>>>
>>> While testing the vmsplice/splice interface of algif_hash I was made
>>> aware of the problem that data blobs larger than 16 pages do not seem to
>>> be hashed properly.
>>>
>>> For testing, a file is mmap()ed and handed to vmsplice / splice. If the
>>> file is smaller than 2**16, the interface returns the proper hash.
>>> However, when the file is larger, only the first 2**16 bytes seem to be
>>> used.
>>>
>>> When adding printk's to hash_sendpage, I see that this function is
>>> invoked exactly 16 times where the first 15 invocations have the
>>> MSG_MORE flag set and the last invocation does not have MSG_MORE.
>> Hi Stephan,
>>
>> I have already noticed the same issue and proposed a patch, but I never
>> got any feedback and it has never been merged, allthought I pinged it a
>> few times.
>>
>> See https://lkml.org/lkml/2014/4/18/276
> After testing, this patch does not work for me. The operation still stops
> after 16 pages.
Yes, it looks like the function I fixed is exclusively used by 
sendfile() system call.
So there is probably the same kind of fix to be done in another function.

Christophe

