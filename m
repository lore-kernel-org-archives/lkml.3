Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3KXWEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 17:04:16 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39580 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3KXWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 17:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAJusiZXN4dOxg9S4ZiCziVXfNZ+=yu7a=84vUikV2RhbhYU7QA@mail.gmail.com>
References: <CAJusiZVq3O1rok20HyYaoJDWxjtBdvMbDtjCif+sCyKPzpXMNA@mail.gmail.com>
	<CAJusiZXN4dOxg9S4ZiCziVXfNZ+=yu7a=84vUikV2RhbhYU7QA@mail.gmail.com>
Date: Sun, 24 Nov 2013 14:04:14 -0800
Message-ID: <CAJusiZVxBg7=GX1-gQjXyyXznKvAnv26EWzVFu59+TBm5mGRsA@mail.gmail.com>
Subject: Re: AF_ALG buggy with sendfile
From: Shawn Landden <shawnlandden@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you build https://kernel.googlesource.com/pub/scm/network/connman/connman/+/0.80/tools/alg-test.c
from the connman source code and compare the output to coreutils
sha1sum you can see the problem.

shawn@debian-T61:~/git/test$ make connman_afalg
cc     connman_afalg.c   -o connman_afalg
shawn@debian-T61:~/git/test$ ./connman_afalg /bin/true
send 27080 bytes
recv 20 bytes
45384483cf9cd0d82eba164131795b4807c6d39d  /bin/true
shawn@debian-T61:~/git/test$ sha1sum /bin/true
82667ba2ec681d8e55b0ee3b6db2970f9911680d  /bin/true

On Sun, Nov 24, 2013 at 2:00 PM, Shawn Landden <shawnlandden@gmail.com> wrote:
> heres a version of the test case that builds.....
>
> Sorry about that.
>
> On Sun, Nov 24, 2013 at 9:21 AM, Shawn Landden <shawnlandden@gmail.com> wrote:
>> If I use sendfile() to send to a accept()ed AF_ALG socket set up for
>> "hash", I get the wrong
>> answer, if I read() and then write() I get the right answer. None of
>> the system calls return an error.
>>
>> test case attached.
>>
>> --
>>
>> ---
>> Shawn Landden
>> +1 360 389 3001 (SMS preferred)
>
>
>
> --
>
> ---
> Shawn Landden
> +1 360 389 3001 (SMS preferred)



-- 

---
Shawn Landden
+1 360 389 3001 (SMS preferred)
