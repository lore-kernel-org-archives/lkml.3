Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHSU0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:26:15 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:52664 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaHSU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <E1XJpsx-0001oD-AE@www17.your-server.de>
References: <E1XJpsx-0001oD-AE@www17.your-server.de>
Date: Tue, 19 Aug 2014 22:26:12 +0200
Message-ID: <CAFLxGvyr-ham--zwR32JnXTy+gd9oe6pksSWBpHm-aiS80Tp0A@mail.gmail.com>
Subject: Re: [UML] 3.16 build without optimization fails
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux@thorsten-knabe.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 10:19 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> Hi.
>
> Thanks for your answer.
>
> There goes my plan to better understand an UML kernel lock up by using a debugger... Everything gets optimised out with -O2 :-(

Is it the filesystem/block lockup you saw some time ago?
Maybe Thorsten can give more details.
He sent me an patch off list a few days ago.

> Can you give an example function that relies on this GCC feature?
>
> With kind regards
> Thomas
>
> Am 19.08.2014 22:06 schrieb Valdis.Kletnieks@vt.edu:
>>
>> On Tue, 19 Aug 2014 21:12:10 +0200, Thomas Meyer said:
>> > > Hi,
>> > >
>> > > the build with -O0 fails with:
>>
>> > > bug or feature?
>> > >
>> > > any ideas?
>>
>> Feature.  The kernel is *known* to not build with -O0, because that
>> disables *all* function inlining, and there's several functions that *have*
>> to be inlined in order to function properly (most notably, anything
>> that uses the gcc __builtin_return_address in a function that is expected
>> to be inlined).



-- 
Thanks,
//richard
