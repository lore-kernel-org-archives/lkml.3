Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaEMBpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:45:10 -0400
Received: from mail-vc0-f195.google.com ([209.85.220.195]:41659 "EHLO
	mail-vc0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaEMBpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <5146762.jba3IJe7xt@wuerfel>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
	<1399861195-21087-3-git-send-email-superlibj8301@gmail.com>
	<5146762.jba3IJe7xt@wuerfel>
Date: Tue, 13 May 2014 09:45:08 +0800
Message-ID: <CAHPCO9FRfR5p1N5v7mUk4hUYdPvqfLN6nW1LcnC83sU86ZFbZA@mail.gmail.com>
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

> On Mon, May 12, 2014 at 3:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 12 May 2014 10:19:55 Richard Lee wrote:
>> For the IO mapping, for the same physical address space maybe
>> mapped more than one time, for example, in some SoCs:
>> 0x20000000 ~ 0x20001000: are global control IO physical map,
>> and this range space will be used by many drivers.
>> And then if each driver will do the same ioremap operation, we
>> will waste to much malloc virtual spaces.
>>
>> This patch add IO mapping space reused support.
>>
>> Signed-off-by: Richard Lee <superlibj@gmail.com>
>
> What happens if the first driver then unmaps the area?
>

If the first driver will unmap the area, it shouldn't do any thing
except decreasing the 'used' counter.

Thanks,

BRs
Richard Lee


>         Arnd
