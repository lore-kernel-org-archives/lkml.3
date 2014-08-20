Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaHTN0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:26:13 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:32832 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbaHTN0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:26:11 -0400
Message-ID: <53F4A1E7.8090504@iki.fi>
Date: Wed, 20 Aug 2014 16:25:59 +0300
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel crypto API: cryptoperf performance measurement
References: <56334718.JSiBY74glM@myon.chronox.de> <53F2FA10.2000300@iki.fi> <1477690.toHy6ei3xC@myon.chronox.de>
In-Reply-To: <1477690.toHy6ei3xC@myon.chronox.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 80.75.107.218
X-SA-Exim-Mail-From: jussi.kivilinna@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-19 21:23, Stephan Mueller wrote:
> Am Dienstag, 19. August 2014, 10:17:36 schrieb Jussi Kivilinna:
> 
> Hi Jussi,
> 
>> Hello,
>>
>> On 2014-08-17 18:55, Stephan Mueller wrote:
>>> Hi,
>>>
>>> during playing around with the kernel crypto API, I implemented a
>>> performance measurement tool kit for the various kernel crypto API cipher
>>> types. The cryptoperf tool kit is provided in [1].
>>>
>>> Comments are welcome.
>>
>> Your results are quite slow compared to, for example "cryptsetup
>> benchmark", which uses kernel crypto from userspace.
>>
>> With Intel i5-2450M (turbo enabled), I get:
>>
>> #  Algorithm | Key |  Encryption |  Decryption
>>      aes-cbc   128b   524,0 MiB/s  11909,1 MiB/s
>>  serpent-cbc   128b    60,9 MiB/s   219,4 MiB/s
>>  twofish-cbc   128b   143,4 MiB/s   240,3 MiB/s
>>      aes-cbc   256b   330,4 MiB/s  1242,8 MiB/s
>>  serpent-cbc   256b    66,1 MiB/s   220,3 MiB/s
>>  twofish-cbc   256b   143,5 MiB/s   221,8 MiB/s
>>      aes-xts   256b  1268,7 MiB/s  4193,0 MiB/s
>>  serpent-xts   256b   234,8 MiB/s   224,6 MiB/s
>>  twofish-xts   256b   253,5 MiB/s   254,7 MiB/s
>>      aes-xts   512b  2535,0 MiB/s  2945,0 MiB/s
>>  serpent-xts   512b   274,2 MiB/s   242,3 MiB/s
>>  twofish-xts   512b   250,0 MiB/s   245,8 MiB/s
> 
> One to four GB per second for XTS? 12 GB per second for AES CBC? Somehow that 
> does not sound right.

Agreed, those do not look correct... I wonder what happened there. On
new run, I got more sane results:

#  Algorithm | Key |  Encryption |  Decryption
     aes-cbc   128b   139,1 MiB/s  1713,6 MiB/s
 serpent-cbc   128b    62,2 MiB/s   232,9 MiB/s
 twofish-cbc   128b   116,3 MiB/s   243,7 MiB/s
     aes-cbc   256b   375,1 MiB/s  1159,4 MiB/s
 serpent-cbc   256b    62,1 MiB/s   214,9 MiB/s
 twofish-cbc   256b   139,3 MiB/s   217,5 MiB/s
     aes-xts   256b  1296,4 MiB/s  1272,5 MiB/s
 serpent-xts   256b   283,3 MiB/s   275,6 MiB/s
 twofish-xts   256b   294,8 MiB/s   299,3 MiB/s
     aes-xts   512b   984,3 MiB/s   991,1 MiB/s
 serpent-xts   512b   227,7 MiB/s   220,6 MiB/s
 twofish-xts   512b   220,6 MiB/s   220,2 MiB/s

-Jussi
