Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3FDO5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:57:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43683 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3FDO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <3489856.nvZgTyoe0K@wuerfel>
References: <1369756498-5670-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<201306041603.15653.arnd@arndb.de>
	<CAHp75VdrXdA7uwpYoo5To-niMn8wSCdwu_p6fArq+Vd6kb-0EA@mail.gmail.com>
	<3489856.nvZgTyoe0K@wuerfel>
Date: Tue, 4 Jun 2013 17:57:38 +0300
Message-ID: <CAHp75VdrsbPfAx8z2nhAtD2dj-YA9b9bZ-MiYW-aNndTFRRHgg@mail.gmail.com>
Subject: Re: [PATCH, resend] pch_phub: re-use native MAC address parser
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 5:38 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 04 June 2013 17:21:16 Andy Shevchenko wrote:
>
>> > The easiest solution would be to
>> > make the entire driver "depend on NET".
>>
>> I don't feel that is good idea. Driver is an abstraction to the ROM,
>> it doesn't mean you can't read ROM without network framework.
>
> Right, makes sense.
>
>> It seems proper solution is to move mac_pton() outside of CONFIG_NET,
>> though I don't know how to do this easily.
>
> If we want to use it outside of CONFIG_NET, it cannot be part of net/core/*.c.
> Maybe we can move the function to lib/mac_pton.c instead and create a
> Kconfig symbol that gets selected by CONFIG_NET and by any driver lib
> PCH_PHUB that needs it.

Sounds like a solution. Would you like me to implement this?


--
With Best Regards,
Andy Shevchenko
