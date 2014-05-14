Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaENCNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 22:13:23 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:39307 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaENCNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 22:13:22 -0400
MIME-Version: 1.0
In-Reply-To: <5026482.P9PDy29y2Y@wuerfel>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
	<5146762.jba3IJe7xt@wuerfel>
	<CAHPCO9FRfR5p1N5v7mUk4hUYdPvqfLN6nW1LcnC83sU86ZFbZA@mail.gmail.com>
	<5026482.P9PDy29y2Y@wuerfel>
Date: Wed, 14 May 2014 10:13:22 +0800
Message-ID: <CAHPCO9GkEHpyr=_nMxKPzPZZ6FaT3-h3n1eZ_-iRbXNiyEea4Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] ARM: ioremap: Add IO mapping space reused support.
From: Richard Lee <superlibj8301@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Lee <superlibj@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 4:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 13 May 2014 09:45:08 Richard Lee wrote:
>> > On Mon, May 12, 2014 at 3:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Monday 12 May 2014 10:19:55 Richard Lee wrote:
>> >> For the IO mapping, for the same physical address space maybe
>> >> mapped more than one time, for example, in some SoCs:
>> >> 0x20000000 ~ 0x20001000: are global control IO physical map,
>> >> and this range space will be used by many drivers.
>> >> And then if each driver will do the same ioremap operation, we
>> >> will waste to much malloc virtual spaces.
>> >>
>> >> This patch add IO mapping space reused support.
>> >>
>> >> Signed-off-by: Richard Lee <superlibj@gmail.com>
>> >
>> > What happens if the first driver then unmaps the area?
>> >
>>
>> If the first driver will unmap the area, it shouldn't do any thing
>> except decreasing the 'used' counter.
>
> Ah, for some reason I didn't see your first patch that introduces
> that counter.
>

It's "[PATCH 1/2] mm/vmalloc: Add IO mapping space reused".

Thanks,

BRs
Richard



>         Arnd
