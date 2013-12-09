Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381Ab3LIVAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:00:37 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45310 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3LIVAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:00:31 -0500
Message-ID: <52A62F68.906@samsung.com>
Date: Tue, 10 Dec 2013 06:00:24 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>,
        Doug Andersen <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>, kgene.kim@samsung.com,
        Ben Dooks <ben-linux@fluff.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: EXYNOS: pmu: Constify data tables
References: <1384971686-7208-1-git-send-email-djkurtz@chromium.org> <1922780.plAOmhqzpW@amdc1227> <CAGS+omDq95paoHsf5-i2gbRoSGvqn36zNO93KHGi2FGhfGMsrw@mail.gmail.com> <30145891.cE1204QWiC@amdc1227>
In-Reply-To: <30145891.cE1204QWiC@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 01:15, Tomasz Figa wrote:
> On Tuesday 10 of December 2013 00:11:40 Daniel Kurtz wrote:
>> Hi Tomasz,
>>
>> Thank you for the reviews.
>>
>> On Dec 9, 2013 5:15 AM, "Tomasz Figa"<t.figa@samsung.com>  wrote:
>>>
>>> Hi Daniel,
>>>
>>> On Thursday 21 of November 2013 02:21:24 Daniel Kurtz wrote:
>>>> These tables are all immutable, make them const to save 4416 bytes of RAM.
>>>>
>>>> size arch/arm/mach-exynos/pmu.o
>>>>     text          data     bss
>>>>      848          4420       4         // before
>>>>     5264             4       4         // after
>>>
>>> I'm not sure where the mentioned saving of RAM is. Moving data between
>>> sections is not supposed to make it use less memory, I believe.
>>
>> You are correct.  This was my misunderstanding from doing too much
>> work with microcontrollers, where .text sections are accessed in place
>> from FLASH for code and const data, but .data memory is copied from a
>> FLASH section to a second RAM section at init for access at runtime.
>> Most modern Linux systems copy/decompress their code and data sections
>> from external storage to RAM anyway, so there is no actual memory
>> savings (except potentially the compiler may be able to optimize a bit
>> more with the const hint).
>>
>>>
>>> Anyway, it's a good practice to mark constant data as const, to disallow
>>> changing them at runtime by mistake, so the patch is fine. Except some
>>> issues I commented on inline.
>>
>> Were there supposed to be inline comments?  I don't see any.
>
> Oops, sorry for this, forgot to remove the last sentence. I initially had
> one question about the constant pointers below, but I read through the
> full code again and answered it myself.
>
> The patch is fine.
>
> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>
OK, applied 1 to 3 patches into cleanup.

Thanks,
Kukjin
