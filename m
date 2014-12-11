Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbaLKWmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:42:17 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62973 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541AbaLKWmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:42:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141211220229.GR18807@outflux.net>
References: <20141211224501.2292cdee@pc> <20141211220229.GR18807@outflux.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 11 Dec 2014 14:41:54 -0800
Message-ID: <CALCETrUVApaHd3tjekXFK4jZbJKj+aKW=xqYPjgTkPrCixM1Xw@mail.gmail.com>
Subject: Re: VDSO randomization not very random
To: Kees Cook <keescook@chromium.org>
Cc: =?UTF-8?Q?Hanno_B=C3=B6ck?= <hanno@hboeck.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 2:02 PM, Kees Cook <keescook@chromium.org> wrote:
> Hi Hanno,
>
> On Thu, Dec 11, 2014 at 10:45:01PM +0100, Hanno Böck wrote:
>> Hello,
>>
>> I already reported this into your bugzilla, however Greg KH told me it
>> might be a better idea to post it here:
>>
>> With current Linux kernels it seems the address randomization for
>> loading the vdso library is not that random and can easily be
>> bruteforced.
>>
>> This can easily be demonstrated. Get libvdso address from one
>> executable:
>> $ ldd /usr/bin/less|grep vdso
>>       linux-vdso.so.1 (0x00007fff73bfe000)
>>
>> Now run ldd mutliple times and check if the same address appears:
>> c=0; while (true); do let c=c+1; ldd /usr/bin/less|grep
>> 0x00007fff73bfe000; [ "$?" == 0 ] && echo $c; done
>>
>> It usually takes only a few seconds and around 1000-2000 tries until
>> the loading address is repeated (note that results may vary, it seems
>> the randomization is biased, some values repeat more often than others).
>>
>> This information is mostly from this blog entry:
>> http://v0ids3curity.blogspot.in/2014/12/return-to-vdso-using-elf-auxiliary.html
>> And here's a thread on oss-security discussing the issue:
>> http://www.openwall.com/lists/oss-security/2014/12/09/10
>>
>> The latest version of paxtest added a check for this that guesses the
>> randomness of vdso:
>> https://grsecurity.net/~spender/paxtest-0.9.13.tar.gz $ ./randvdso
>> VDSO randomisation test                  : 11 quality bits (guessed)
>>
>> Bugzilla entry:
>> https://bugzilla.kernel.org/show_bug.cgi?id=89591
>
> I'm hoping this will get addressed as part of the discussion around
> the "ASLRv3" patches. PIE (as well as VDSO) randomization has been a
> per-arch implementation, and it would be best to unify this in a common
> high-entropy solution.
>
> I think the problem with VDSO right now is that it is randomized in
> relationship to the stack, rather than being randomized on its own.
>

As far as I'm concerned, the vdso can go wherever the kernel wants to
put it, so long as it doesn't conflict with any real-world non-PIE
binaries.

--Andy

> -Kees
>
> --
> Kees Cook
> Chrome OS Security



-- 
Andy Lutomirski
AMA Capital Management, LLC
