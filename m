Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaEHTbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:31:46 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44004 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbaEHTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:31:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140508094606.GE3320@darkstar.nay.redhat.com>
References: <20140424023544.GA2180@darkstar.nay.redhat.com>
	<CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
	<20140424025016.GB2180@darkstar.nay.redhat.com>
	<CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
	<20140508094606.GE3320@darkstar.nay.redhat.com>
Date: Thu, 8 May 2014 12:31:44 -0700
X-Google-Sender-Auth: 0_GFTH_E4nhWxPVwC8c5ptY5x8M
Message-ID: <CAGXu5j+VbEYWH80mvY3wQscqqfkDpKkKv81xQa-qmUz-mqHF2Q@mail.gmail.com>
Subject: Re: kaslr should avoid setup_data region
From: Kees Cook <keescook@chromium.org>
To: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 2:46 AM, Dave Young <dyoung@redhat.com> wrote:
> On 04/24/14 at 03:50pm, Kees Cook wrote:
>> On Wed, Apr 23, 2014 at 7:50 PM, Dave Young <dyoung@redhat.com> wrote:
>> > On 04/23/14 at 07:43pm, Kees Cook wrote:
>> >> On Wed, Apr 23, 2014 at 7:35 PM, Dave Young <dyoung@redhat.com> wrote:
>> >> > Hello Kees
>> >> >
>> >> > I'm worrying that setup_data regions could be overwitten by randomize
>> >> > kernel base. Would you like to fix it in kaslr code?
>> >> >
>> >> > One problem is there could be a lot of setup_data regions but current
>> >> > mem_avoid is an fixed array.
>> >>
>> >> Sure, can you give me some examples? Seems like it shouldn't be too
>> >> hard to have the mem_avoid logic walk additional areas.
>> >
>> > Great, To walk through the list just like the function parse_setup_data in
>> > arch/x86/kernel/setup.c
>
> One problem for me is that I am not sure how to read the setup_data memory
> and iterate it, I think early_ioremap is not available that early. BTW the
> setup_data region could be above 4G.
>
> Appreciate for any hints.

Hm, I'm not sure. The kASLR code only deals with memory that has been
set up during the physical/virtual identity mapping.

-Kees

-- 
Kees Cook
Chrome OS Security
