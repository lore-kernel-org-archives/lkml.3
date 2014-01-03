Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaACANb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:13:31 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37931 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaACAN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:13:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140102192745.GB2025@core.coreip.homeip.net>
References: <20131231193442.GA25208@core.coreip.homeip.net>
	<CAD=FV=VjYtXA5XHiuz-bULpW_MCBWxw2eTvg+SQz9CrgsER4AA@mail.gmail.com>
	<20140102192745.GB2025@core.coreip.homeip.net>
Date: Thu, 2 Jan 2014 16:13:27 -0800
X-Google-Sender-Auth: zhozzTfk6ulLK1bgFMqVKx_EdJE
Message-ID: <CAA25o9Tf_wEnJ1H4tKVXbS4R3pgbh6nbEWChEyjzRRDcusYRFg@mail.gmail.com>
Subject: Re: [PATCH] Input: cros_ec_keyb - switch from using uint8_t to u8
From: Luigi Semenzato <semenzato@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>, linux-input@vger.kernel.org,
        Simon Glass <sjg@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, this is useful information, and it would be even more
useful if it made it in Documentation/CodingStyle :-)



On Thu, Jan 2, 2014 at 11:27 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Jan 02, 2014 at 08:12:09AM -0800, Doug Anderson wrote:
>> Dmitry,
>>
>> On Tue, Dec 31, 2013 at 11:34 AM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > u8 is proper in-kernel type for unsigned byte data.
>>
>> I won't say that I keep up with all the latest trends here, but this
>> surprised me so I did some research.  My findings don't agree with
>> your statement.  Perhaps there are different standards that are used
>> for the input subsystem?
>>
>> Specifically looking at
>> <https://www.kernel.org/doc/Documentation/CodingStyle>, I see:
>>
>>      Therefore, the Linux-specific 'u8/u16/u32/u64' types and their
>>      signed equivalents which are identical to standard types are
>>      permitted -- although they are not mandatory in new code of your
>>      own.
>>
>>      When editing existing code which already uses one or the other set
>>      of types, you should conform to the existing choices in that code.
>>
>> That makes it sound like the author of that document would prefer
>> uint8_t but will accept u8.  It also seems like if code is consistent
>> about using a given type (as this code is) that it shouldn't be
>> changed.
>>
>> I'm always happy to be enlightened, though!
>
> I prefer uXX in kernel because it matches __uXX that we publish in UAPI.
> Also here is Linus's response form the discussion that introduced that
> particular wording in CodingStyle [1]:
>
> "The problem with uint32_t is that it's ugly, it used to be unportable,
> and you can't use it in header files _anyway_.
>
> In other words, there's no _point_ to the "standard type".
>
> I really object to this whole thing. The fact is, "u8" and friends _are_
> the standard types as far as the kernel is concerned.  Claiming that
> they aren't is just silly.
>
> It's the "uint32_t" kind of thing that isn't standard within the kernel.
> You can't use that thing in public header files anyway due to name
> scoping rules, so they have basically no redeeming features."
>
> Thanks.
>
> --
> Dmitry
>
> [1] http://marc.info/?l=linux-kernel&m=114659539715468&w=2
