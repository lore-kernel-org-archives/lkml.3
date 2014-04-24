Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbaDXWxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:53:39 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47704 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbaDXWuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:50:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140424025016.GB2180@darkstar.nay.redhat.com>
References: <20140424023544.GA2180@darkstar.nay.redhat.com>
	<CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
	<20140424025016.GB2180@darkstar.nay.redhat.com>
Date: Thu, 24 Apr 2014 15:50:06 -0700
X-Google-Sender-Auth: _6KC_Dapj1Yp5Dv10rXP68YslIE
Message-ID: <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
Subject: Re: kaslr should avoid setup_data region
From: Kees Cook <keescook@chromium.org>
To: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, it sounds like boot_params.hdr.setup_data contains a series of
e820-like entries chained together as a linked list? Which loaders
currently populate that? Looks like EFI? Seems like
arch/x86/boot/compressed/eboot.c works on setup_data at least.

I won't be in a position to test EFI booting for a while. If someone
else took this, that would make it get fixed much faster.

Do you have examples where this is actually causing failures?

-Kees

On Wed, Apr 23, 2014 at 7:50 PM, Dave Young <dyoung@redhat.com> wrote:
> On 04/23/14 at 07:43pm, Kees Cook wrote:
>> On Wed, Apr 23, 2014 at 7:35 PM, Dave Young <dyoung@redhat.com> wrote:
>> > Hello Kees
>> >
>> > I'm worrying that setup_data regions could be overwitten by randomize
>> > kernel base. Would you like to fix it in kaslr code?
>> >
>> > One problem is there could be a lot of setup_data regions but current
>> > mem_avoid is an fixed array.
>>
>> Sure, can you give me some examples? Seems like it shouldn't be too
>> hard to have the mem_avoid logic walk additional areas.
>
> Great, To walk through the list just like the function parse_setup_data in
> arch/x86/kernel/setup.c
>
> Thanks
> Dave



-- 
Kees Cook
Chrome OS Security
