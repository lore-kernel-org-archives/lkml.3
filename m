Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218AbaE3ROd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:14:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64961 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810AbaE3RO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:14:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5388BC62.50501@roeck-us.net>
Date: Fri, 30 May 2014 10:14:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, satoru.takeuchi@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3.14 000/140] 3.14.5-stable review
References: <20140529043049.661315084@linuxfoundation.org>	<53874CE2.2010701@roeck-us.net>	<20140529182109.GA10142@kroah.com>	<20140529210708.GA26023@roeck-us.net> <CA+55aFws44CBn4SOBdxrQ8T6kt6xXL3wFi-JNvW6fUPBWAxA=g@mail.gmail.com>
In-Reply-To: <CA+55aFws44CBn4SOBdxrQ8T6kt6xXL3wFi-JNvW6fUPBWAxA=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 02:27 PM, Linus Torvalds wrote:
> On Thu, May 29, 2014 at 2:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Thu, May 29, 2014 at 11:21:09AM -0700, Greg Kroah-Hartman wrote:
>>> On Thu, May 29, 2014 at 08:06:10AM -0700, Guenter Roeck wrote:
>>>>
>>>> alpha:defconfig                     - Fails with 'Inconsistent kallsyms data'. New failure; need to debug.
>>>>
>>>> Bisect points to commit 'vlan: Fix lockdep warning with stacked vlan devices' as culprit
>>>> for the alpha:defconfig build failure. Reverting this patch fixes the problem.
>>>> I looked at the patch, but I have no idea what may cause the failure.
>>>
>>> Odd.  Is this also broken in Linus's tree?
>>>
>> Agreed, it is odd. As I said, not idea what is causing this.
>> v3.15-rc7 is fine.
>
> The bisection is almost certainly bogus, and this 'inconsistent
> kallsyms data' issue is not new. I thought we fixed it, but it's
> possible that there are alpha-specific issues and/or that it depends
> on binutils versions.
>
> In particular, when we've seen it in the past, it has depended on
> exact alignment of code or data, which is why random changes
> (particularly to percpu data) can seem to trigger it. Basically, two
> symbols getting the same address and then being sorted differently by
> 'nm' or similar.
>
> See for example
>
>    http://marc.info/?l=linux-next&m=133267456809502&w=2
>
> where it hits ARM and rmk actually debugged that particular case.
>
> Adding Michal to the cc, because I have a dim memory of this being
> fixed, but I can't remember how. I hope Michal does.. Or maybe the
> fact that alpha is hit by this just means that I mis-remember.
>

For now I "solved" the build problem by adding KALLSYMS_EXTRA_PASS=1"
to alpha builds.

Guenter

