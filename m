Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3FDOV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:21:28 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58015 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab3FDOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <201306041603.15653.arnd@arndb.de>
References: <1369756498-5670-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<201306041603.15653.arnd@arndb.de>
Date: Tue, 4 Jun 2013 17:21:16 +0300
Message-ID: <CAHp75VdrXdA7uwpYoo5To-niMn8wSCdwu_p6fArq+Vd6kb-0EA@mail.gmail.com>
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

On Tue, Jun 4, 2013 at 5:03 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 28 May 2013, Andy Shevchenko wrote:
>> We have mac_pton() helper to parse MAC addresses.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> Hmm, the patch has appeared in linux-next now, and I'm now getting
> randconfig build errors when CONFIG_NET is disabled, since
> mac_pton is undefined then.

Thanks for catching this.

> The easiest solution would be to
> make the entire driver "depend on NET".

I don't feel that is good idea. Driver is an abstraction to the ROM,
it doesn't mean you can't read ROM without network framework.
It seems proper solution is to move mac_pton() outside of CONFIG_NET,
though I don't know how to do this easily.

--
With Best Regards,
Andy Shevchenko
