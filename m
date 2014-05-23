Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaEWJRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:17:17 -0400
Received: from mout.gmx.net ([212.227.17.20]:64624 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaEWJRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:17:14 -0400
Message-ID: <537F1208.8090800@gmx.de>
Date: Fri, 23 May 2014 11:16:56 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: Re: Linux 3.15-rc6
References: <CA+55aFzwqPh+WUAxi2CY8D6k+LkDbUb__G98qVFrE-DHNMSPUw@mail.gmail.com>	<20140522172032.GA20975@roeck-us.net>	<CA+55aFw_kOE1Y4qkLW4rWfB_NaYYDwFeU=t5swsJCTMq-3J6nA@mail.gmail.com>	<537E9F47.5020809@roeck-us.net>	<CA+55aFzk3Xw8VsYMmiGvXxzrkh7zenFUrpyobaK_q+17PSh=ww@mail.gmail.com> <CAJfpeguNGFDw_7C1JgZv3Wjgd0ku9QhEkUy_+gprOS58sBXaSQ@mail.gmail.com>
In-Reply-To: <CAJfpeguNGFDw_7C1JgZv3Wjgd0ku9QhEkUy_+gprOS58sBXaSQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:5gb2pM5VE4mXt0hrPqDBu+9B3Lh4m4HOzlZFyC87MwYPXO/RplI
 UfSdHwLNA5xqdR7XrB3oLajfXX9uv3u2eBxkwUFUryydJfkEdQZ/63spN7CTNy6fZoYTWby
 HdmvUmQzLA0OgBek0GrOjcALUcpAlUKRmBKSgvagIWupOTPTOtClxqlwxJAVG2Ax1AZYu/s
 /QE+HJvAA3ty1Ux2tixBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 11:12 AM, Miklos Szeredi wrote:
> On Fri, May 23, 2014 at 3:27 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, May 22, 2014 at 6:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>> On 05/22/2014 05:43 PM, Linus Torvalds wrote:
>>>>
>>>>
>>>> only s390 seems to need a compat wrapper, and s390 is kind of odd in
>>>> many respects, so I suspect renameat2 should just use ENTRY_SAME() on
>>>> parisc, but without any way to *test* it I won't apply the patch.
>>>>
>>>> Guenter, I assume that changing the
>>>>
>>>>          ENTRY_COMP(renameat2)
>>>>
>>>> line in arch/parisc/kernel/syscall_table.S to use ENTRY_SAME() at
>>>> least fixes the compile error?
>>>
>>> Yes, it fixes the build error for parisc64, and parisc (32 bit) still
>>> builds.
>>
>> Ok. I'd like to get some kind of confirmation that it is expected to
>> work too. Miklos/Helge?
> 
> Oops, yes, it should be ENTRY_SAME().

Yes, ENTRY_SAME() is correct. Sorry, it was my fault that I didn't noticed earlier.

Helge
