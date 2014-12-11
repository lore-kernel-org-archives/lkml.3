Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbaLKBpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:45:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbaLKBpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:45:52 -0500
Message-ID: <5488F432.5010405@redhat.com>
Date: Wed, 10 Dec 2014 20:32:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Daniel J Blueman <daniel@quora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, 3.18] sleeping function called from invalid context
References: <CAMVG2su302Nvtp+fnaOjtLadJFtpPmVXiN5YfQ0JpT920YohuA@mail.gmail.com> <CALCETrXZpQyKbVkBMwqFq2wH908-V+WCuvtaTc1O9VNZFHrBUQ@mail.gmail.com> <CAMVG2svoTbm3k3W5POpLsJnpXBPpZRYVr+wmAQrWVGVtiQ=LRA@mail.gmail.com> <5488EA01.6020600@redhat.com> <CALCETrVGH0VbGDWEx-D=gU7o3keM6PgGfYLixADH-sgNxhxJDA@mail.gmail.com>
In-Reply-To: <CALCETrVGH0VbGDWEx-D=gU7o3keM6PgGfYLixADH-sgNxhxJDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/10/2014 07:51 PM, Andy Lutomirski wrote:
> On Wed, Dec 10, 2014 at 4:49 PM, Rik van Riel <riel@redhat.com>
> wrote: On 12/10/2014 07:46 PM, Daniel J Blueman wrote:
>>>> Gah. I had some non-temporal copy changes in the wrong tree.
>>>> I'll check with a definitely clean tree and follow up if it
>>>> still occurs.
> 
> The exception handlers should definitely allow sleeping, so I
> suspect those changes may be related.
> 
>> It would be really, really nice if we could arrange for 
>> kernel_fpu_begin to be unconditionally usable in anything except
>> NMI context.  The crypto code would be much less scary, we could
>> make non-temporal copies safe, etc.  Can we have ponies, too?

Isn't it already?

I see nothing in __kernel_fpu_begin that looks like it would
ever need to sleep.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUiPQyAAoJEM553pKExN6DKJoH/iWa64YibC17ADt2F7Uq4sSD
7gsi7oG7t/WJGUH5QbWy3O+36ppTw2lZwLMUUlPMqHaqzyhNa8TkGr2auyJyH45h
vk7YCBpHjzqGB8IUxgbeaie6n95Z8RG28FP8HOB1EjCwQwqJR3lQqnvRP6QD17FX
H/I9+w5+Hdkcu0sNj8jppdap+q6Bu/y1WHli3iWIlHMJIsfMMmkmiZR/Gw0ewf0w
F8bePmQYQjyB/xkEPtfXFGUuJfnbLYkYFyHUHHe/J+/MI1VkKNPDBGelvNKwniEC
41R7KinuqVh6DiAa9WprAXcrmllHI4L5aIFIRWI/W03/omFrF6WAdWs8OXioHfI=
=s4Eb
-----END PGP SIGNATURE-----
