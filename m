Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbaJOF5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:57:05 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39531 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJOF5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <543E0A25.80401@gmail.com>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
 <542B4DA3.5080105@gmail.com> <542B519B.6010001@landley.net>
 <542B5E44.40303@gmail.com> <542B7200.6030902@landley.net> <CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>
 <20141001180510.GA28540@cloud> <CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
 <20141014140052.2f114c158ffe6cd953020f1c@linux-foundation.org>
 <CALCETrXB337oy2BcL3Y-U1CZDqR7TMPxsR9b9R=EatWvvc4zfg@mail.gmail.com> <543E0A25.80401@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Oct 2014 22:56:39 -0700
Message-ID: <CALCETrV5K15EPDiPvCFhxCHuZ6J4+S=KniOE-WkBgpiVkLLk4w@mail.gmail.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
To: Frank Rowand <frowand.list@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 10:46 PM, Frank Rowand <frowand.list@gmail.com> wrote:
> On 10/14/2014 2:21 PM, Andy Lutomirski wrote:
>> On Tue, Oct 14, 2014 at 2:00 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Wed, 1 Oct 2014 11:13:14 -0700 Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>>> On Wed, Oct 1, 2014 at 11:05 AM,  <josh@joshtriplett.org> wrote:
>>>>> On Tue, Sep 30, 2014 at 09:53:56PM -0700, Andy Lutomirski wrote:
>>>>>> I significantly prefer default N.  Scripts that play with init= really
>>>>>> don't want the fallback, and I can imagine contexts in which it could
>>>>>> be a security problem.
>>>>>
>>>>> While I certainly would prefer the non-fallback behavior for init as
>>>>> well, standard kernel practice has typically been to use "default y" for
>>>>> previously built-in features that become configurable.  And I'd
>>>>> certainly prefer a compile-time configuration option like this (even
>>>>> with default y) over a "strictinit" kernel command-line option.
>>>>>
>>>>
>>>> Fair enough.
>>>>
>>>> So: "default y" for a release or two, then switch the default?  Having
>>>> default y will annoy virtme, though it's not the end of the world.
>>>> Virtme is intended to work with more-or-less-normal kernels.
>>>>
>>>
>>> Adding another Kconfig option is tiresome.  What was wrong with strictinit=?
>>
>> The consensus seems to be that adding a non-default option to get
>
>       ^^^^^^^^^  I do not think you know what the word consensus means. :-)
>
> I did not agree.
>
> I do agree with Andrew (but with no opinion on whether "strictinit=SOMETHING"
> or just "strictinit".
>
>> sensible behavior would be unfortunate.  Also, I don't like

Even you're not disagreeing that it's ugly, though, FWIW.

>   ^^^^^^^^^^^^^^^^^
>   behavior that is useful in some or many contexts

Is there a context in which the current behavior is useful beyond
"whoops, I typoed my grub command line edit, and I still want my
system to boot into *something* even if it's the wrong thing"?  I'm
not personally that sympathetic to that particular use case, but maybe
there's another one.

--Andy

>
>> strictinit=, since backwards-compatible setups will have to do
>> init=foo strictinit=foo.  My original proposal was init=foo
>> strictinit.
>>
>> TBH, my preference would be to make strict mode unconditional.
>> http://xkcd.com/1172/
>>
>> --Andy
>>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
