Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaHTSOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:14:16 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:46428 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaHTSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:14:14 -0400
Message-ID: <53F4E571.7030003@gmail.com>
Date: Wed, 20 Aug 2014 20:14:09 +0200
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
CC: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel crypto API: cryptoperf performance measurement
References: <56334718.JSiBY74glM@myon.chronox.de> <53F2FA10.2000300@iki.fi> <1477690.toHy6ei3xC@myon.chronox.de> <53F4A1E7.8090504@iki.fi>
In-Reply-To: <53F4A1E7.8090504@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 03:25 PM, Jussi Kivilinna wrote:
>> One to four GB per second for XTS? 12 GB per second for AES CBC? Somehow that 
>> does not sound right.
> 
> Agreed, those do not look correct... I wonder what happened there. On
> new run, I got more sane results:

Which cryptsetup version are you using?

There was a bug in that test on fast machines (fixed in 1.6.3, I hope :)

But anyway, it is not intended as rigorous speed test,
it was intended for comparison of ciphers speed on particular machine.

Test basically tries to encrypt 1MB block (or multiple of this
if machine is too fast). All it runs through kernel userspace crypto API
interface.
(Real FDE is always slower because it runs over 512bytes blocks.)

Milan


> 
> #  Algorithm | Key |  Encryption |  Decryption
>      aes-cbc   128b   139,1 MiB/s  1713,6 MiB/s
>  serpent-cbc   128b    62,2 MiB/s   232,9 MiB/s
>  twofish-cbc   128b   116,3 MiB/s   243,7 MiB/s
>      aes-cbc   256b   375,1 MiB/s  1159,4 MiB/s
>  serpent-cbc   256b    62,1 MiB/s   214,9 MiB/s
>  twofish-cbc   256b   139,3 MiB/s   217,5 MiB/s
>      aes-xts   256b  1296,4 MiB/s  1272,5 MiB/s
>  serpent-xts   256b   283,3 MiB/s   275,6 MiB/s
>  twofish-xts   256b   294,8 MiB/s   299,3 MiB/s
>      aes-xts   512b   984,3 MiB/s   991,1 MiB/s
>  serpent-xts   512b   227,7 MiB/s   220,6 MiB/s
>  twofish-xts   512b   220,6 MiB/s   220,2 MiB/s
> 
> -Jussi
> 

